import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/presentation/bloc/chat_session_bloc.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.secondUserUid});

  final String secondUserUid;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void handleMessageSending(BuildContext context) {
    if (_messageController.text.isEmpty) {
      return;
    }

    final message = Message(
      id: "",
      senderId: "",
      receiverId: widget.secondUserUid,
      text: _messageController.text.trim(),
      timestamp: .now(),
    );

    final chatRoom = ChatRoom(
      roomId: "",
      participantIds: [widget.secondUserUid],
      lastMessage: _messageController.text.trim(),
      lastMessageTime: .now(),
      otherUserName: "Guest",
      isOnline: true,
    );

    context.read<ChatSessionBloc>().add(
      SendMessage(chatRoom: chatRoom, message: message),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ChatSessionBloc>()
            ..add(LoadIndividualChatRoomMessages(widget.secondUserUid)),
      child: Builder(
        builder: (context) {
          return BlocListener<ChatSessionBloc, ChatSessionState>(
            listener: (context, state) {
              print('Current state of chat session: $state');
              if (state is ChatSessionFailure) {
                SnackbarHelper.showError(context, state.message, showTop: true);
              }
              if (state is ChatSessionSuccess) {
                SnackbarHelper.showSuccess(context, 'your message sent!');
              }
            },
            child: Scaffold(
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
                    ),

                    Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .center,
                      children: [
                        // name
                        Text(
                          'Cody Fisher',
                          style: AppTextStyle.bodySemiBold(
                            context,
                            fontSize: 12,
                          ),
                        ),

                        // online status
                        Row(
                          spacing: ResponsiveDimensions.spacing4(context),
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.success,
                              radius: ResponsiveDimensions.spacing4(context),
                            ),

                            Text(
                              'Online',
                              style: AppTextStyle.bodyRegular(
                                context,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    BlocBuilder<ChatSessionBloc, ChatSessionState>(
                      builder: (context, state) {
                        if (state is ChatSessionChatRoomMessagesLoaded) {
                          if (state.messages.isNotEmpty) {
                            return ListView.builder(
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                return Text(state.messages[index].text);
                              },
                            );
                          }
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    Spacer(),
                    Row(
                      spacing: ResponsiveDimensions.spacing12(context),
                      children: [
                        Expanded(
                          child: CustomTextField(
                            isFilled: true,
                            fillColor: AppColors.divider,
                            hintText: "write your message",
                            maxLines: 1,
                            controller: _messageController,
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
                            onPressed: () => handleMessageSending(context),
                            icon: SvgPicture.asset(ImageConstant.sendIcon),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveDimensions.spacing8(context)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
