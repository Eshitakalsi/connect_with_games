// ignore_for_file: deprecated_member_use

import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_circle_distance_calculator/great_circle_distance_calculator.dart';
import 'package:intl/intl.dart';

class GameItem extends StatelessWidget {
  final String userName;
  final String userId;
  final String gameName;
  final Timestamp gameTime;
  final String gameType;
  final double lat;
  final double lng;
  final double distance;
  GameItem(
      {this.userId,
      this.userName,
      this.gameName,
      this.gameTime,
      this.gameType,
      this.lat,
      this.lng,
      this.distance});
  Future<void> connectUsers() async {
    String append = userId.compareTo(LoggedInUserInfo.id) > 0
        ? userId + LoggedInUserInfo.id
        : LoggedInUserInfo.id + userId;
    try {
      final image = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final imageUrl = image.data()['image_url'];
      await FirebaseFirestore.instance.collection('Chats').doc(append).set({
        'idOne': userId,
        'idTwo': LoggedInUserInfo.id,
        'userNameOne': userName,
        'userNameTwo': LoggedInUserInfo.name,
        'imageOne': imageUrl,
        'imageTwo': LoggedInUserInfo.url
      });
    } on PlatformException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameTime.toDate().isBefore(DateTime.now())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (gameType == 'Physical' &&
        LoggedInUserInfo.userFilters.isPhysical == false) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (gameType == 'Computer' &&
        LoggedInUserInfo.userFilters.isComputer == false) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (gameType == 'Physical') {
      var distanceBetweenPlaces = GreatCircleDistance.fromDegrees(
          latitude1: lat,
          latitude2: LoggedInUserInfo.userFilters.lat,
          longitude1: lng,
          longitude2: LoggedInUserInfo.userFilters.lng);
      double maxDistance = distanceBetweenPlaces.vincentyDistance() / 1000;
      if (maxDistance > distance ||
          maxDistance > LoggedInUserInfo.userFilters.distance) {
        return Container(
          height: 0,
          width: 0,
        );
      }
    }
    if (LoggedInUserInfo.userFilters.gameDate != null) {
      DateTime date1 = gameTime.toDate();
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
                  this.gameName,
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
                  'Date : ${DateFormat.yMMMd().format(gameTime.toDate())}',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ListTile(
                  leading: Text(
                    'Type : ${this.gameType}',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  title: Text(
                    'Added by : $userName',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  trailing: OutlineButton.icon(
                    borderSide: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    label: Text(
                      "Play",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    onPressed: () {
                      connectUsers();
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
