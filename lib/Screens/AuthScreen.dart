// ignore_for_file: deprecated_member_use
import 'package:animate_do/animate_do.dart';
import 'package:connect_with_games/Auth/AuthForm.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/one.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              stops: [0.3, 0.9],
              colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.2),
              ],
            ),
          ),
          child: Row(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: deviceSize.height,
                  width: deviceSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 44.0),
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1000),
                            delay: Duration(milliseconds: 100),
                            from: 70,
                            child: Text(
                              'ConnectUGames',
                              style: TextStyle(
                                color: Color.fromRGBO(40, 40, 40, 1),
                                fontSize: 45,
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AuthForm(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
