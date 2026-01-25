import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/date_formatter.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.otherUser,
    required this.currentUserId,
  });
  final Chat chat;
  final ChatUser otherUser;
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.lastMessage;
    final isUnread =
        lastMessage?.isRead == false && lastMessage?.senderId != currentUserId;

    return Padding(
      padding: ResponsiveDimensions.paddingOnly(context, bottom: 16),
      child: Dismissible(
        key: Key(chat.chatId),
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.spacing16(context),
          ),
          decoration: BoxDecoration(color: AppColors.primaryPressed),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          return null;

          // await _deleteChat(context, chat.chatId);
          // return false; // Don't auto-dismiss, let BLoC handle it
        },
        child: GestureDetector(
          onTap: () {
            final authState = context.read<AuthCubit>().state as Authenticated;
            context.router.push(
              ChatRoute(
                currentUser: ChatUser(
                  uid: authState.currentUser!.uid,
                  name: authState.currentUser!.username,
                  email: authState.currentUser!.email,
                ),
                otherUser: otherUser,
              ),
            );
          },
          child: Column(
            spacing: ResponsiveDimensions.spacing12(context),
            children: [
              Row(
                crossAxisAlignment: .start,
                spacing: ResponsiveDimensions.spacing12(context),
                children: [
                  // profile image
                  CircleAvatar(
                    radius: ResponsiveDimensions.getSize(context, 28),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: otherUser.profileImage != null
                        ? NetworkImage(otherUser.profileImage!)
                        : null,
                    child: otherUser.profileImage == null
                        ? Text(
                            otherUser.name[0].toUpperCase(),
                            style: AppTextStyle.bodySemiBold(
                              context,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  Row(
                    crossAxisAlignment: .start,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          SizedBox(
                            height: ResponsiveDimensions.spacing4(context),
                          ),
                          // name
                          Text(
                            otherUser.name,
                            style: AppTextStyle.bodySemiBold(context),
                          ),

                          // last message
                          if (lastMessage != null)
                            SizedBox(
                              width: ResponsiveDimensions.getSize(context, 170),
                              child: Text(
                                lastMessage.text,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: AppTextStyle.bodyRegular(
                                  context,
                                  color: isUnread
                                      ? AppColors.textPrimary
                                      : AppColors.textHint,
                                ),
                              ),
                            ),
                        ],
                      ),

                      if (lastMessage != null)
                        Padding(
                          padding: ResponsiveDimensions.paddingOnly(
                            context,
                            top: 4,
                          ),
                          child: Text(
                            DateFormatter.formatChatListTime(
                              lastMessage.timestamp,
                            ),
                            style: AppTextStyle.labelMedium(
                              context,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              Padding(
                padding: ResponsiveDimensions.paddingOnly(context, left: 74),
                child: Divider(color: AppColors.divider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
