import 'package:websocket_lan_chat/src/models/user.dart';

class Message {
  User author;
  String body;

  Message({this.author, this.body});

  factory Message.fromJson(Map<String, dynamic> json) =>
      new Message(author: User.fromJson(json['author']), body: json['body']);

  Map<String, dynamic> toJson() => {'author': author.toJson(), 'body': body};
}
