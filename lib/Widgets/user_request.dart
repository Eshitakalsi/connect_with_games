import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequest extends StatelessWidget {
  final gameId;
  final snapshot;
  final gameName;
  UserRequest({this.gameId, this.snapshot, this.gameName});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: NetworkImage(snapshot.data['image_url']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            snapshot.data['firstName'],
            style: TextStyle(fontSize: 20),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[300],
                  ),
                  onPressed: () {
                    cancelRequest(context, snapshot.data.id);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green[300],
                  ),
                  onPressed: () {
                    acceptRequest(snapshot.data.id);
                  },
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Future<void> acceptRequest(id) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('Games')
          .doc(gameId)
          .get();

      List requested = doc['requestedUsers'];
      requested.remove(id);
      List joined = doc['joinedUsers'];
      joined.add(id);

      await FirebaseFirestore.instance
          .collection('userRequestedGames')
          .doc(id + "#" + gameId)
          .delete();
      await FirebaseFirestore.instance
          .collection('userJoinedGames')
          .doc(id + "#" + gameId)
          .set({"gameId": gameId});

      await FirebaseFirestore.instance.collection('Games').doc(gameId).update({
        'requestedUsers': requested,
        'joinedUsers': joined,
      });
      String append = id.compareTo(LoggedInUserInfo.id) > 0
          ? id + LoggedInUserInfo.id
          : LoggedInUserInfo.id + id;
      final image =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      final imageUrl = image.data()['image_url'];
      await FirebaseFirestore.instance.collection('Chats').doc(append).set({
        'idOne': id,
        'idTwo': LoggedInUserInfo.id,
        'userNameOne': snapshot.data['firstName'],
        'userNameTwo': LoggedInUserInfo.name,
        'imageOne': imageUrl,
        'imageTwo': LoggedInUserInfo.url
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> denyRequest(id) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('Games')
          .doc(gameId)
          .get();

      List l = doc['requestedUsers'];
      l.remove(id);
      await FirebaseFirestore.instance
          .collection('userRequestedGames')
          .doc(id + "#" + gameId)
          .delete();
      await FirebaseFirestore.instance
          .collection('Games')
          .doc(gameId)
          .update({'requestedUsers': l});

      return;
    } catch (error) {
      print("...");
    }
  }

  cancelRequest(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, sets) {
          return AlertDialog(
            title: Text('Are you sure?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  denyRequest(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}
