import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Screens/AboutScreen.dart';
import 'package:connect_with_games/Screens/HypertrackScreen.dart';
import 'package:connect_with_games/Screens/NewWelcomeScreen.dart';
import 'package:connect_with_games/Screens/ProfileScreen.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  Future<void> googleSignOut(context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    LoggedInUserInfo.id = null;
    LoggedInUserInfo.name = null;

    Navigator.popUntil(
      context,
      ModalRoute.withName("hello"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              elevation: 0,
              title: Text(
                'ConnectUGames',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 25,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.w600,
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.home,
                color: accentColor,
              ),
              title: Text("Home"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => NewWelcomeScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: accentColor,
              ),
              title: Text("Profile"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: accentColor,
              ),
              title: Text("About Us"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => AboutScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: accentColor,
              ),
              title: Text("Location"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => HyperTrackQuickStart()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: accentColor,
              ),
              title: Text("Logout"),
              onTap: () {
                googleSignOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
