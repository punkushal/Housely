import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:housely/features/chat/presentation/widgets/chat_card.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ChatListPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => sl<ChatListBloc>(), child: this);
  }
}

class _ChatPageState extends State<ChatListPage> {
  final ScrollController _scrollController = .new();

  @override
  void initState() {
    super.initState();
    _loadChats();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadChats() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<ChatListBloc>().add(
        LoadChatList(userId: authState.currentUser!.uid),
      );
    }
  }

  /// Set up scroll listener for pagination
  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        _loadMoreChats();
      }
    });
  }

  /// Load more chats when scrolling down
  void _loadMoreChats() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<ChatListBloc>().add(
        LoadMoreChats(authState.currentUser!.uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message')),
      body: BlocConsumer<ChatListBloc, ChatListState>(
        listener: (context, state) {
          // Show error messages
          if (state is ChatListError) {
            SnackbarHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          // Loading state
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state is ChatListError) {
            return _buildErrorWidget(state.message);
          }

          // Loaded state
          if (state is ChatListLoaded) {
            if (state.chats.isEmpty) {
              return _buildEmptyWidget();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatListBloc>().add(RefreshChatList());
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.all(
                  ResponsiveDimensions.spacing16(context),
                ),
                itemCount: state.chats.length + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                    SizedBox(height: ResponsiveDimensions.spacing12(context)),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end
                  if (index == state.chats.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final chat = state.chats[index];
                  final currentUserId =
                      (context.read<AuthCubit>().state as Authenticated)
                          .currentUser!
                          .uid;

                  // Get other user details
                  final otherUserId = chat.participants.firstWhere(
                    (id) => id != currentUserId,
                    orElse: () => '',
                  );
                  final otherUser = chat.participantDetails[otherUserId];

                  if (otherUser == null) return const SizedBox.shrink();

                  return ChatCard(
                    chat: chat,
                    otherUser: otherUser,
                    currentUserId: currentUserId,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: ResponsiveDimensions.spacing16(context)),
          Text(
            'No conversations yet',
            style: AppTextStyle.headingSemiBold(
              context,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: AppColors.error),
            SizedBox(height: ResponsiveDimensions.spacing16(context)),
            Text(
              'Something went wrong',
              style: AppTextStyle.headingSemiBold(context),
            ),
            SizedBox(height: ResponsiveDimensions.spacing8(context)),
            Text(
              message,
              style: AppTextStyle.bodyRegular(
                context,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveDimensions.spacing16(context)),
            ElevatedButton(onPressed: _loadChats, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
