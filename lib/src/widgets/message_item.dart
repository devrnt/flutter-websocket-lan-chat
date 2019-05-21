import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket_lan_chat/src/models/message.dart';
import 'package:websocket_lan_chat/src/models/user.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  MessageItem({@required this.message});

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Align(
      alignment: message.author.name == user.name
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Chip(
        backgroundColor: message.author.color,
        padding: EdgeInsets.all(4),
        label: Text(message.body),
        avatar: CircleAvatar(
          backgroundColor: message.author.color,
          radius: 100.0,
          backgroundImage: NetworkImage(message.author.imageUrl),
          // child: Image.network(message.author.imageUrl),
        ),
      ),
    );
  }
}
