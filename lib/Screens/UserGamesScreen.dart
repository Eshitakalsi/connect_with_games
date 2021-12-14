import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Widgets/user_game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserGamesScreen extends StatelessWidget {
  static const routeName = "/UserGamesScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Your Games'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(1, 1, 1, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Games')
            .where('userId', isEqualTo: LoggedInUserInfo.id)
            .snapshots(),
        builder: (ctx, gamesSnapshot) {
          if (gamesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List gameDocs = gamesSnapshot.data.docs;
          return ListView.builder(
            itemCount: gameDocs.length,
            itemBuilder: (ctx, index) {
              return UserGameItem(
                gameId: gameDocs[index].id,
                gameName: gameDocs[index]['gameName'],
                gameType: gameDocs[index]['gameType'],
                playDate: gameDocs[index]['playDate'],
                distanceRange: gameDocs[index]['distanceRange'],
                lat: gameDocs[index]['latitude'],
                lng: gameDocs[index]['longitude'],
              );
            },
          );
        },
      ),
    );
  }
}
