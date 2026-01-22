import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/chat/presentation/widgets/chat_card.dart';

@RoutePage()
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message')),
      body: Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: ListView(children: [ChatCard(), ChatCard(), ChatCard()]),
      ),
    );
  }
}
