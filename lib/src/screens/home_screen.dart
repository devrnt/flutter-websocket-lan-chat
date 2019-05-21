import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomeScreen extends StatelessWidget {
  final channel = IOWebSocketChannel.connect('ws://192.168.0.229:8080');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          return Container(
              color: Colors.pink,
              child: Center(
                  child: Text(snapshot.hasData ? '${snapshot.data}' : '')));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call_missed_outgoing),
        onPressed: _sendMessage,
      ),
    );
  }

  void _sendMessage() {
    // TODO: is LAN ip working or is localhost needed
    channel.sink.add('Hello!');
  }
}
