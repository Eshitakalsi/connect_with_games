import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/Widgets/history_game.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserGameHistory extends StatefulWidget {
  static const routeName = "/GamingHistory";

  @override
  _UserGameHistoryState createState() => _UserGameHistoryState();
}

class _UserGameHistoryState extends State<UserGameHistory> {
  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Playing History'),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(1, 1, 1, 1),
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchString = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: (searchString == null || searchString.trim() == "")
                    ? FirebaseFirestore.instance.collection('Games').snapshots()
                    : FirebaseFirestore.instance
                        .collection('Games')
                        .where("searchindex",
                            arrayContains: searchString.toLowerCase())
                        .snapshots(),
                builder: (ctx, gamesSnapshot) {
                  if (gamesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final gameDocs = gamesSnapshot.data.docs;
                  return ListView.builder(
                      itemCount: gameDocs.length,
                      itemBuilder: (ctx, index) {
                        return HistoryGame(
                            ss: gameDocs[index],
                            gameId: gameDocs[index].id,
                            userId: gameDocs[index]['userId'],
                            userName: gameDocs[index]['userName'],
                            gameName: gameDocs[index]['gameName'],
                            gameType: gameDocs[index]['gameType'],
                            gameTime: gameDocs[index]['playDate'],
                            lat: gameDocs[index]['latitude'],
                            lng: gameDocs[index]['longitude'],
                            distance: gameDocs[index]['distanceRange']);
                      });
                },
              ),
            ),
          ],
        ));
  }
}
