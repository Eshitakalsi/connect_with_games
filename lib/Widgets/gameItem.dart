// ignore_for_file: deprecated_member_use

import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_circle_distance_calculator/great_circle_distance_calculator.dart';
import 'package:intl/intl.dart';

class GameItem extends StatefulWidget {
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
  GameItem(
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
  State<GameItem> createState() => _GameItemState();
}

class _GameItemState extends State<GameItem> {
  Future<void> sendOrDeleteRequest() async {
    List l = widget.ss['requestedUsers'];
    if (l.contains(LoggedInUserInfo.id)) {
      l.remove(LoggedInUserInfo.id);
      await FirebaseFirestore.instance
          .collection('userRequestedGames')
          .doc(LoggedInUserInfo.id + "#" + widget.gameId)
          .delete();
      await FirebaseFirestore.instance
          .collection('Games')
          .doc(widget.gameId)
          .update({'requestedUsers': l});
      setState(() {});

      return;
    }
    final doc1 = await FirebaseFirestore.instance
        .collection('userJoinedGames')
        .doc(LoggedInUserInfo.id + "#" + widget.gameId)
        .get();
    if (doc1.exists) {
      setState(() {});

      return;
    }

    l.add(LoggedInUserInfo.id);
    await FirebaseFirestore.instance
        .collection('Games')
        .doc(widget.gameId)
        .update({'requestedUsers': l});

    await FirebaseFirestore.instance
        .collection('userRequestedGames')
        .doc(LoggedInUserInfo.id + "#" + widget.gameId)
        .set({"gameId": widget.gameId});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameTime.toDate().isBefore(DateTime.now())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (widget.gameType == 'Physical' &&
        LoggedInUserInfo.userFilters.isPhysical == false) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (widget.gameType == 'Computer' &&
        LoggedInUserInfo.userFilters.isComputer == false) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (widget.gameType == 'Physical') {
      var distanceBetweenPlaces = GreatCircleDistance.fromDegrees(
          latitude1: widget.lat,
          latitude2: LoggedInUserInfo.userFilters.lat,
          longitude1: widget.lng,
          longitude2: LoggedInUserInfo.userFilters.lng);
      double maxDistance = distanceBetweenPlaces.vincentyDistance() / 1000;
      if (maxDistance > widget.distance ||
          maxDistance > LoggedInUserInfo.userFilters.distance) {
        return Container(
          height: 0,
          width: 0,
        );
      }
    }
    if (LoggedInUserInfo.userFilters.gameDate != null) {
      DateTime date1 = widget.gameTime.toDate();
      DateTime date2 = DateTime.parse(LoggedInUserInfo.userFilters.gameDate);
      if (date1.year != date2.year ||
          date1.month != date2.month ||
          date1.day != date2.day) {
        return Container(
          height: 0,
          width: 0,
        );
      }
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
                  trailing:
                      widget.ss['joinedUsers'].contains(LoggedInUserInfo.id)
                          ? OutlineButton.icon(
                              borderSide: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              label: Text(
                                'Joined',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.thumb_up,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            )
                          : OutlineButton.icon(
                              borderSide: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              label: widget.ss['requestedUsers']
                                      .contains(LoggedInUserInfo.id)
                                  ? Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Play',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              onPressed: () {
                                sendOrDeleteRequest();
                              },
                              icon: Icon(
                                Icons.thumb_up,
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
