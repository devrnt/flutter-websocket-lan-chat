import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket_lan_chat/src/models/user.dart';
import 'package:websocket_lan_chat/src/screens/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                filled: true,
                border: InputBorder.none,
                hintText: 'What\'s your name?',
              ),
            ),
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text('Next'),
              onPressed: _createUser,
            ),
          ],
        ),
      ),
    );
  }

  void _createUser() {
    // TODO: move logic to other widget
    final List<Color> colors = [
      Colors.pink,
      Colors.teal,
      Colors.blue,
      Colors.orange,
      Colors.yellow,
      Colors.purple,
      Colors.red
    ];

    final List<String> imageUrls = [
      'https://cdn4.iconfinder.com/data/icons/user-avatar-flat-icons/512/User_Avatar-04-512.png',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4LRADmE5sIaCA5kC7SaM2WDgzUH_ngB30-rgL6xfIcFdbnsUW',
      'https://image.flaticon.com/icons/png/512/306/306473.png',
      'https://banner2.kisspng.com/20180403/tkw/kisspng-avatar-computer-icons-user-profile-business-user-avatar-5ac3a1f7d96614.9721182215227704238905.jpg'
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkYcbCCLAF3opunLo7FJ7si5fwDhQJp0C__SpRM3QxSpVKJYOa',
    ];

    colors.shuffle();
    imageUrls.shuffle();

    Random random = new Random();

    int indexImage = random.nextInt(imageUrls.length - 1);
    int indexColor = random.nextInt(colors.length - 1);

    final User user = new User(
        name: textEditingController.text,
        imageUrl: imageUrls[indexImage],
        color: colors[indexColor]);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Provider<User>(
              builder: (_) => user,
              child: MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: HomeScreen()),
            ),
      ),
    );
  }
}
