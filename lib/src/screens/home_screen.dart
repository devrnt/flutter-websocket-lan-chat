import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:websocket_lan_chat/config/config.dart';
import 'package:websocket_lan_chat/src/widgets/message_input.dart';
import 'package:websocket_lan_chat/src/widgets/message_list.dart';
import 'package:websocket_lan_chat/src/models/user.dart';
import 'package:websocket_lan_chat/src/models/message.dart';

// TODO: move to provdider
User _user = new User(
    name: 'Jonas',
    imageUrl:
        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    color: Colors.green);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final IOWebSocketChannel channel =
      IOWebSocketChannel.connect('ws://${Config.ip}:${Config.port}');

  final TextEditingController _textEditingController =
      new TextEditingController();

  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  if (snapshot.data == null) {
                    return Center(
                        child: Text('No messages yet, start typing...'));
                  } else {
                    Message message =
                        Message.fromJson(jsonDecode(snapshot.data));
                    messages.add(message);
                  }
                  return MessageList(messages: messages);
                },
              ),
            ),
            Expanded(
              child: MessageInput(
                textEditingController: _textEditingController,
                onPressed: _sendMessage,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage() {
    final messageBody = _textEditingController.text;

    final Message message = new Message(author: _user, body: messageBody);
    final jsonMessage = jsonEncode(message);

    channel.sink.add(jsonMessage);

    _textEditingController.clear();
  }
}
