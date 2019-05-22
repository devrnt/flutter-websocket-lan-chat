import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:websocket_lan_chat/data/data.dart';
import 'package:websocket_lan_chat/src/models/message.dart';
import 'package:websocket_lan_chat/src/models/user.dart';
import 'package:websocket_lan_chat/src/widgets/message_input.dart';
import 'package:websocket_lan_chat/src/widgets/message_item.dart';
import 'package:websocket_lan_chat/src/widgets/message_list.dart';

void main() {
  group('MessageInput', () {
    testWidgets('on message send, the input field is cleared', (tester) async {
      var _textEditingController = new TextEditingController();
      Function _onPressed = () => _textEditingController.clear();
      var messageInput = MessageInput(
        textEditingController: _textEditingController,
        onPressed: _onPressed,
      );
      final String inputText = 'This is my message';

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: messageInput)));

      expect(find.byType(IconButton), findsOneWidget);

      await tester.enterText(find.byType(TextField), inputText);
      expect(find.text(inputText), findsOneWidget);

      await tester.tap(find.byType(IconButton));

      expect(find.text(inputText), findsNothing);
    });
  });

  group('MessageItem', () {
    testWidgets('message item has a message field and a circleavatar',
        (tester) async {
      var _message = new Message(
          author: Data.user, body: 'Message body', id: new Uuid().v1());

      var messageInput = MessageItem(
        message: _message,
      );

      await provideMockedNetworkImages(() async {
        await tester.pumpWidget(Provider<User>(
          builder: (_) => Data.user,
          child: MaterialApp(home: Scaffold(body: messageInput)),
        ));
      });

      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('messages sent by user are right aligned', (tester) async {
      final message = new Message(
          author: Data.user, body: 'Message body', id: new Uuid().v1());

      await provideMockedNetworkImages(() async {
        await tester.pumpWidget(Provider<User>(
          builder: (_) => Data.user,
          child:
              MaterialApp(home: Scaffold(body: MessageItem(message: message))),
        ));
      });

      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((widget) =>
              widget is Align && widget.alignment == Alignment.topRight),
          findsOneWidget);
    });

    testWidgets('messages sent by someone else are left aligned',
        (tester) async {
      final otherUser = new User(
          name: 'OtherUser',
          imageUrl: 'https://i.stack.imgur.com/pcS8T.png',
          color: Colors.green);

      final message = new Message(
          author: otherUser,
          body: 'Message by someone else',
          id: new Uuid().v1());

      await provideMockedNetworkImages(() async {
        await tester.pumpWidget(Provider<User>(
            builder: (_) => Data.user,
            child: MaterialApp(
                home: Scaffold(body: MessageItem(message: message)))));
      });

      expect(
          find.byWidgetPredicate((widget) =>
              widget is Align && widget.alignment == Alignment.topLeft),
          findsOneWidget);
    });

    group('MessageList', () {
      testWidgets('messages are correctly displayed in a list', (tester) async {
        var messages = <Message>[
          new Message(
              author: Data.user, body: 'Message body', id: new Uuid().v1()),
          new Message(
              author: Data.user, body: 'Message body', id: new Uuid().v1()),
        ];

        var messageList = MessageList(messages: messages);

        await provideMockedNetworkImages(() async {
          await tester.pumpWidget(Provider<User>(
            builder: (_) => Data.user,
            child: MaterialApp(home: Scaffold(body: messageList)),
          ));
        });

        expect(find.byType(MessageItem), findsNWidgets(messages.length));
      });
    });
  });
}
