// ignore_for_file: deprecated_member_use

import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryGame extends StatefulWidget {
  var ss;
  final String gameId;
  final String userName;
  final String userId;
  final String gameName;
  final Timestamp gameTime;
  final String gameType;
  final double lat;
  final double lng;
  final double distance;
  HistoryGame(
      {this.ss,
      this.gameId,
      this.userId,
      this.userName,
      this.gameName,
      this.gameTime,
      this.gameType,
      this.lat,
      this.lng,
      this.distance});

  @override
  State<HistoryGame> createState() => _HistoryGameState();
}

class _HistoryGameState extends State<HistoryGame> {
  @override
  Widget build(BuildContext context) {
    if (widget.gameTime.toDate().isAfter(DateTime.now())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    List l = widget.ss['joinedUsers'];
    if (((l.contains(LoggedInUserInfo.id)) == false) &&
        (widget.userId != LoggedInUserInfo.id)) {
      return Container(
        height: 0,
        width: 0,
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Card(
        color: accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {},
          splashColor: Theme.of(context).primaryColor,
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.widget.gameName,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Date : ${DateFormat.yMMMd().format(widget.gameTime.toDate())}',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ListTile(
                  leading: Text(
                    'Type : ${this.widget.gameType}',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  title: Text(
                    'Added by : ${widget.userName}',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
