import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Widgets/gameItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SearchFiltersScreen.dart';

// ignore: must_be_immutable
class DisplayAvailableGames extends StatefulWidget {
  static const routeName = "/DisplayAvailableGames";

  @override
  _DisplayAvailableGamesState createState() => _DisplayAvailableGamesState();
}

class _DisplayAvailableGamesState extends State<DisplayAvailableGames> {
  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Available Games'),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(1, 1, 1, 1),
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => SearchFiltersScreen()));
                  if (result == null) {
                  } else {
                    setState(() {});
                  }
                })
          ],
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
                        if (gameDocs[index]['userId'] == LoggedInUserInfo.id) {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        }
                        print(gameDocs[index].id);
                        return GameItem(
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
