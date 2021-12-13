import 'package:connect_with_games/Screens/AboutScreen.dart';
import 'package:connect_with_games/Screens/NewWelcomeScreen.dart';
import 'package:connect_with_games/Screens/ProfileScreen.dart';

import './Models/loggedInUserInfo.dart';
import './Screens/AuthScreen.dart';
import './Screens/DisplayAvailableGames.dart';
import './Screens/IndividualChatScreen.dart';
import './Screens/IntermediateMainScreen.dart';
import './Screens/PhoneAuthScreen.dart';
import './Screens/UserGamesScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './commons/theme.dart';

import 'Providers/Auth.dart';

import 'Screens/AddGameScreen.dart';
import 'Screens/HypertrackScreen.dart';
import 'Screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(51, 153, 255, .1),
  100: Color.fromRGBO(51, 153, 255, .2),
  200: Color.fromRGBO(51, 153, 255, .3),
  300: Color.fromRGBO(51, 153, 255, .4),
  400: Color.fromRGBO(51, 153, 255, .5),
  500: Color.fromRGBO(51, 153, 255, .6),
  600: Color.fromRGBO(51, 153, 255, .7),
  700: Color.fromRGBO(51, 153, 255, .8),
  800: Color.fromRGBO(51, 153, 255, .9),
  900: Color.fromRGBO(51, 153, 255, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ConnectUGames',
        theme: ThemeData(
          // ignore: deprecated_member_use
          primarySwatch: MaterialColor(0xFFC0B283, color),
          primaryColor: primaryColor,
          errorColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          fontFamily: 'Raleway',
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, AsyncSnapshot<User> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }

            if (userSnapshot.hasData) {
              LoggedInUserInfo.email = userSnapshot.data.email;
              LoggedInUserInfo.phoneNo = userSnapshot.data.phoneNumber;
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userSnapshot.data.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> ss) {
                  if (ss.connectionState == ConnectionState.waiting) {
                    return SplashScreen();
                  } else if (ss.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          "Something went wrong! Please try again!",
                        ),
                      ),
                    );
                  } else {
                    if (ss.data.data() != null) {
                      LoggedInUserInfo.phoneNo = userSnapshot.data.phoneNumber;
                      LoggedInUserInfo.email = userSnapshot.data.email;
                      LoggedInUserInfo.id = userSnapshot.data.uid;
                      LoggedInUserInfo.name = ss.data['firstName'];
                      LoggedInUserInfo.url = ss.data['image_url'];
                      LoggedInUserInfo.gender = ss.data['gender'];
                      return NewWelcomeScreen();
                    } else {
                      return IntermediateMainScreen(
                          userSnapshot.data.uid,
                          userSnapshot.data.email,
                          userSnapshot.data.phoneNumber);
                    }
                  }
                },
              );
            }
            return AuthScreen();
          },
        ),
        initialRoute: '/',
        routes: {
          'hello': (context) => NewWelcomeScreen(),
          NewWelcomeScreen.routeName: (ctx) => NewWelcomeScreen(),
          PhoneAuthScreen.routeName: (ctx) => PhoneAuthScreen(),
          AddGame.routeName: (ctx) => AddGame(),
          DisplayAvailableGames.routeName: (ctx) => DisplayAvailableGames(),
          IndividualChatScreen.routeName: (ctx) => IndividualChatScreen(),
          UserGamesScreen.routeName: (ctx) => UserGamesScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          AboutScreen.routeName: (ctx) => AboutScreen(),
          HyperTrackQuickStart.routeName: (ctx) => HyperTrackQuickStart(),
        },
      ),
    );
  }
}
