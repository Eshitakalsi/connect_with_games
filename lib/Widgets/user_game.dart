// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/Helpers/location_helper.dart';
import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Screens/RequestLists.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserGameItem extends StatelessWidget {
  final gameId;
  final gameName;
  final gameType;
  final playDate;
  final distanceRange;
  final lat;
  final lng;
  String address;

  UserGameItem(
      {this.gameId,
      this.gameName,
      this.gameType,
      this.playDate,
      this.distanceRange,
      this.lat,
      this.lng});
  Future<void> _getAddress() async {
    if (lat != null && lng != null) {
      address = await LocationHelper.getPlaceAddress(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (DateTime.now().isAfter(playDate.toDate())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    return FutureBuilder(
      future: _getAddress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 0,
            width: 0,
          );
        }
        return Dismissible(
            key: ValueKey(gameId),
            onDismissed: (direction) async {
              await FirebaseFirestore.instance
                  .collection('Games')
                  .doc(gameId)
                  .delete();
            },
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Are You Sure?'),
                    content: Text("Do you want to delete your Game?"),
                    actions: <Widget>[
                      FlatButton(
                          child: Text(
                            'No',
                            style: TextStyle(color: Colors.black87),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          }),
                      FlatButton(
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.black87),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          }),
                    ],
                  );
                },
              );
            },
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red[400],
              child: Icon(Icons.delete, color: Colors.white, size: 40),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            ),
            child: InkWell(
              onLongPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => RequestLists(gameId, gameName),
                  ),
                );
              },
              child: Container(
                height: 210,
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                child: Stack(
                  children: [
                    Container(
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 20,
                                  ),
                                  child: Text(
                                    this.gameName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 50,
                                    top: 15,
                                  ),
                                  child: Text(
                                    'Type : ${this.gameType}',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 8,
                                    top: 15,
                                  ),
                                  child: Text(
                                    this.distanceRange == null
                                        ? ''
                                        : 'Range : ${this.distanceRange} KM',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            // Separator(),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 40,
                                    top: 8,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                    top: 8,
                                  ),
                                  child: Text(
                                    'Date : ${DateFormat.yMd().add_jm().format(playDate.toDate())}',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 80,
                                    top: 8,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text(
                                this.address == null
                                    ? ''
                                    : 'Address : ${this.address}',
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        height: 124,
                        margin: EdgeInsets.only(left: 46),
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      alignment: FractionalOffset.centerLeft,
                      child: Container(
                        width: 85,
                        height: 95,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: NetworkImage(LoggedInUserInfo.url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
