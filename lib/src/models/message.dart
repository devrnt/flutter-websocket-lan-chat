import 'package:websocket_lan_chat/src/models/user.dart';

class Message {
  String id;
  User author;
  String body;

  Message({this.id, this.author, this.body});

  factory Message.fromJson(Map<String, dynamic> json) => new Message(
      id: json['id'],
      author: User.fromJson(json['author']),
      body: json['body']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'author': author.toJson(), 'body': body};
}
