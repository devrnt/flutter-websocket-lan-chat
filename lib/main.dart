import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket_lan_chat/data/data.dart';
import 'package:websocket_lan_chat/src/models/user.dart';
import 'package:websocket_lan_chat/src/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<User>(
      builder: (_) => Data.user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
