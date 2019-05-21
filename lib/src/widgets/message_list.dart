import 'package:flutter/material.dart';

import 'package:websocket_lan_chat/src/widgets/message_item.dart';
import 'package:websocket_lan_chat/src/models/message.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  MessageList({this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) => MessageItem(message: messages[index]),
    );
  }
}
