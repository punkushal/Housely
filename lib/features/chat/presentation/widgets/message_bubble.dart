import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/date_formatter.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isMe});
  final Message message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveDimensions.spacing8(context)),
      child: Column(
        crossAxisAlignment: isMe ? .end : .start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  ResponsiveDimensions.radiusSmall(context, size: 10),
                ),
                topRight: Radius.circular(
                  ResponsiveDimensions.radiusSmall(context, size: 10),
                ),
                bottomLeft: Radius.circular(
                  isMe
                      ? ResponsiveDimensions.radiusSmall(context, size: 10)
                      : 0,
                ),
                bottomRight: Radius.circular(
                  isMe
                      ? 0
                      : ResponsiveDimensions.radiusSmall(context, size: 10),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reply preview if exists
                if (message.replyToMessageId != null)
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveDimensions.spacing8(context),
                    ),
                    margin: EdgeInsets.only(
                      bottom: ResponsiveDimensions.spacing4(context),
                    ),
                    decoration: BoxDecoration(
                      color: (isMe ? Colors.white : Colors.grey.shade300)
                          .withValues(alpha: 0.3),
                      borderRadius: ResponsiveDimensions.borderRadiusSmall(
                        context,
                      ),
                    ),
                    child: Text(
                      'Replying to a message',
                      style: AppTextStyle.bodyRegular(
                        context,
                        fontSize: 12,
                        color: isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),

                // Message text
                Text(
                  message.text,
                  style: AppTextStyle.bodyRegular(
                    context,
                    fontSize: 14,
                    color: isMe ? AppColors.surface : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.spacing4(context)),
              ],
            ),
          ),

          // Timestamp
          Text(
            DateFormatter.formatMessageTime(message.timestamp),
            style: AppTextStyle.bodyRegular(
              context,
              fontSize: 10,
              lineHeight: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
