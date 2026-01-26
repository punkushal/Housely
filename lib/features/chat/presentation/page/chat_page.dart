import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/chat_utils.dart';
import 'package:housely/core/utils/date_formatter.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/presentation/bloc/chat_session_bloc.dart';
import 'package:housely/features/chat/presentation/widgets/message_bubble.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ChatPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatPage({
    super.key,
    required this.currentUser,
    required this.otherUser,
  });
  final ChatUser currentUser;
  final ChatUser otherUser;

  @override
  State<ChatPage> createState() => _ChatPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ChatSessionBloc>(
      create: (context) => sl<ChatSessionBloc>(),
      child: this,
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  String? _replyToMessageId;
  // String? _replyToMessageText;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Set up scroll listener for loading more messages
  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context.read<ChatSessionBloc>().add(LoadMoreMessages());
      }
    });
  }

  /// Initialize chat session
  void _initializeChat() {
    context.read<ChatSessionBloc>().add(
      InitializeChat(
        currentUser: widget.currentUser,
        otherUser: widget.otherUser,
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final state = context.read<ChatSessionBloc>().state;
    if (state is! ChatSessionLoaded) return;

    context.read<ChatSessionBloc>().add(
      SendMessage(
        chatId: ChatUtils.generateChatId(
          widget.currentUser.uid,
          widget.otherUser.uid,
        ),
        message: _messageController.text.trim(),
        senderId: widget.currentUser.uid,
        senderName: widget.currentUser.name,
        senderImage: widget.currentUser.profileImage,
        recipientUid: widget.otherUser.uid,
        recipientName: widget.otherUser.name,
        recipientImage: widget.otherUser.profileImage,
        replyToMessageId: _replyToMessageId,
      ),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: .infinity,
        leading: Row(
          spacing: ResponsiveDimensions.spacing8(context),
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back),
            ),

            // profile image
            CircleAvatar(
              radius: ResponsiveDimensions.spacing24(context),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: widget.otherUser.profileImage != null
                  ? NetworkImage(widget.otherUser.profileImage!)
                  : null,
              child: widget.otherUser.profileImage == null
                  ? Text(
                      widget.otherUser.name[0].toUpperCase(),
                      style: AppTextStyle.bodySemiBold(
                        context,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                // name
                Text(
                  widget.otherUser.name,
                  style: AppTextStyle.bodySemiBold(context, fontSize: 12),
                ),

                // online status
                Row(
                  spacing: ResponsiveDimensions.spacing4(context),
                  children: [
                    BlocBuilder<ChatSessionBloc, ChatSessionState>(
                      builder: (context, state) {
                        if (state is ChatSessionLoaded) {
                          return CircleAvatar(
                            backgroundColor: state.isOtherUserOnline
                                ? AppColors.success
                                : AppColors.textHint,
                            radius: ResponsiveDimensions.spacing4(context),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                    BlocBuilder<ChatSessionBloc, ChatSessionState>(
                      builder: (context, state) {
                        if (state is ChatSessionLoaded) {
                          return Text(
                            state.isOtherUserOnline
                                ? "Online"
                                : state.otherUserLastSeen != null
                                ? "Last seen ${DateFormatter.formatLastSeen(state.otherUserLastSeen!)}"
                                : "Offline",
                            style: AppTextStyle.bodyRegular(
                              context,
                              color: state.isOtherUserOnline
                                  ? AppColors.success
                                  : AppColors.textHint,
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatSessionBloc, ChatSessionState>(
              listener: (context, state) {
                // Show error messages
                if (state is ChatSessionLoaded && state.errorMessage != null) {
                  SnackbarHelper.showError(context, state.errorMessage!);
                } else if (state is ChatSessionFailure) {
                  SnackbarHelper.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is ChatSessionLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is ChatSessionLoaded) {
                  return Padding(
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 24,
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.messages.length + (state.isLoadingMore ? 1 : 0),
                      reverse: true,
                      itemBuilder: (context, index) {
                        // Show loading indicator at the end
                        if (state.isLoadingMore &&
                            index == state.messages.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final message = state.messages[index];
                        final isMe = message.senderId == widget.currentUser.uid;

                        return MessageBubble(message: message, isMe: isMe);
                      },
                    ),
                  );
                }

                return const Center(child: Text("Start a conversation"));
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 24,
                vertical: 12,
              ),
              child: Row(
                spacing: ResponsiveDimensions.spacing12(context),
                children: [
                  Expanded(
                    child: CustomTextField(
                      isFilled: true,
                      fillColor: AppColors.divider,
                      controller: _messageController,
                      hintText: "write your message",
                      textCapitalization: .sentences,
                    ),
                  ),

                  Container(
                    width: ResponsiveDimensions.getSize(context, 44),
                    height: ResponsiveDimensions.getSize(context, 44),
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: AppColors.primaryPressed,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _sendMessage();
                      },
                      icon: SvgPicture.asset(ImageConstant.sendIcon),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
