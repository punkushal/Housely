import 'dart:developer';

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
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/chat/presentation/bloc/chat_session_bloc.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ChatPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatPage({super.key, this.owner});
  final PropertyOwner? owner;

  @override
  State<ChatPage> createState() => _ChatPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ChatSessionBloc>(
      create: (context) {
        final bloc = sl<ChatSessionBloc>();
        final authState = context.read<AuthCubit>().state as Authenticated;
        if (owner != null) {
          bloc.add(
            InitializeChat(
              currentUserId: authState.currentUser!.uid,
              otherUserId: owner!.ownerId,
              currentUserName: authState.currentUser!.username,
              otherUserName: owner!.name,
            ),
          );
        }

        return bloc;
      },
      child: this,
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleMessageSending() {
    if (_messageController.text.isEmpty) return;

    if (widget.owner != null) {
      context.read<ChatSessionBloc>().add(
        SendMessage(
          chatId: "", // here is empty because in my datasource i added it there
          message: _messageController.text.trim(),
          receiverId: widget.owner!.ownerId,
          senderId: (context.read<AuthCubit>().state as Authenticated)
              .currentUser!
              .uid,
        ),
      );

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatSessionBloc, ChatSessionState>(
      listener: (context, state) {
        log('current state of chat sesssion: $state');
        if (state is ChatSessionFailure) {
          SnackbarHelper.showError(context, state.message, showTop: true);
        }
        if (state is ChatSessionSuccess) {
          SnackbarHelper.showSuccess(context, 'your message sent!');
        }

        if (state is MessageSendFailure) {
          SnackbarHelper.showError(context, state.message);
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
              CircleAvatar(radius: ResponsiveDimensions.spacing24(context)),

              Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  // name
                  Text(
                    widget.owner != null ? widget.owner!.name : 'No name',
                    style: AppTextStyle.bodySemiBold(context, fontSize: 12),
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
                      onPressed: () {
                        _handleMessageSending();
                      },
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
  }
}
