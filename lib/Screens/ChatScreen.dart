import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Widgets/Chat/chatItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Connections'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(1, 1, 1, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Chats').snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = chatSnapshot.data.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              if (chatDocs[index]['idOne'] == LoggedInUserInfo.id) {
                return ChatItem(chatDocs[index]['userNameTwo'],
                    chatDocs[index]['idTwo'], chatDocs[index]['imageTwo']);
              } else if (chatDocs[index]['idTwo'] == LoggedInUserInfo.id) {
                return ChatItem(chatDocs[index]['userNameOne'],
                    chatDocs[index]['idOne'], chatDocs[index]['imageOne']);
              } else {
                return Container(
                  height: 0,
                  width: 0,
                );
              }
            },
          );
        },
      ),
    );
  }
}
