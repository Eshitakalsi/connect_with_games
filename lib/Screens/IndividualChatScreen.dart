import 'package:connect_with_games/Widgets/Chat/Messages.dart';
import 'package:connect_with_games/Widgets/Chat/NewMessage.dart';
import 'package:flutter/material.dart';

class IndividualChatScreen extends StatelessWidget {
  static const routeName = "/IndividualChatScreen";
  @override
  Widget build(BuildContext context) {
    String chatPartnerId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(1, 1, 1, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(chatPartnerId)),
            NewMessage(chatPartnerId),
          ],
        ),
      ),
    );
  }
}
