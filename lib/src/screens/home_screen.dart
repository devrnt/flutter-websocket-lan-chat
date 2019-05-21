import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:websocket_lan_chat/config/config.dart';
import 'package:websocket_lan_chat/src/models/user.dart';
import 'package:websocket_lan_chat/src/widgets/message_input.dart';
import 'package:websocket_lan_chat/src/widgets/message_list.dart';
import 'package:websocket_lan_chat/src/models/message.dart';

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
                    // This makes sure that the last messages is not just duplicated
                    // into the messages list
                    if (messages.isEmpty) {
                      messages.add(message);
                    } else {
                      if (message.id != messages.last.id) {
                        messages.add(message);
                      }
                    }
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
    final User user = Provider.of<User>(context);

    final messageBody = _textEditingController.text;

    final Message message =
        new Message(id: new Uuid().v1(), author: user, body: messageBody);
    final jsonMessage = jsonEncode(message);

    channel.sink.add(jsonMessage);

    _textEditingController.clear();
  }
}
