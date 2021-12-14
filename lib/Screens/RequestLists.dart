import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/Widgets/user_request.dart';
import 'package:flutter/material.dart';

class RequestLists extends StatefulWidget {
  final String _gameId;
  final String _gameName;
  RequestLists(this._gameId, this._gameName);
  @override
  _RequestListsState createState() => _RequestListsState();
}

class _RequestListsState extends State<RequestLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          title: Text("Requests"),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Games')
              .doc(widget._gameId)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return ListView.builder(
              itemCount: snapshot.data['requestedUsers'].length,
              itemBuilder: (ctx, idx) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot.data['requestedUsers'][idx])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return UserRequest(
                        gameId: widget._gameId,
                        snapshot: snapshot,
                        gameName: widget._gameName);
                  },
                );
              },
            );
          }),
    );
  }
}
