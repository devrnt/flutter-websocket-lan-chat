import 'package:flutter/material.dart';
import 'package:websocket_lan_chat/src/models/user.dart';

class Data {
  static User user = new User(
      name: 'Jonas',
      imageUrl:
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      color: Colors.green);
}
