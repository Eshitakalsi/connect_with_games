// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Screens/UserGameHistory.dart';
import 'package:connect_with_games/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';

import 'package:connect_with_games/Helpers/Filters.dart';
import 'package:connect_with_games/Helpers/location_helper.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'AddGameScreen.dart';
import 'ChatScreen.dart';
import 'DisplayAvailableGames.dart';
import 'UserGamesScreen.dart';

class NewWelcomeScreen extends StatefulWidget {
  static const routeName = "/NewWelcomeScreen";

  @override
  _NewWelcomeScreenState createState() => _NewWelcomeScreenState();
}

class _NewWelcomeScreenState extends State<NewWelcomeScreen> {
  CarouselController _carouselController = new CarouselController();
  int _current = 0;

  List<dynamic> _options = [
    {
      'title': 'FIND A GAME',
      'image': 'assets/images/six.jpeg',
      'description': 'Find what you feel like playing!',
      'name': 'FIND'
    },
    {
      'title': 'ADD A GAME',
      'image': 'assets/images/seven.jpeg',
      'description': 'Post a game to play with others!',
      'name': 'ADD'
    },
    {
      'title': 'YOUR GAMES',
      'image': 'assets/images/eight.jpeg',
      'description': 'See what you added!',
      'name': 'GO'
    },
    {
      'title': 'Gaming History',
      'image': 'assets/images/seven.jpeg',
      'description': 'Check your gaming history!',
      'name': 'HISTORY'
    }
  ];

  bool _isLoading = false;

  void myGames() {
    Navigator.pushNamed(context, UserGamesScreen.routeName);
  }

  void addGames() {
    Navigator.pushNamed(context, AddGame.routeName);
  }

  void gamingHistory() {
    Navigator.pushNamed(context, UserGameHistory.routeName);
  }

  Future<void> lookForGame() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('defaultValues/${LoggedInUserInfo.id}')) {
      setState(() {
        _isLoading = false;
      });
      Map<String, dynamic> result =
          jsonDecode(prefs.getString('defaultValues/${LoggedInUserInfo.id}'));
      if (result['gameDate'] != null &&
          DateTime.parse(result['gameDate']).isBefore(DateTime.now())) {
        LoggedInUserInfo.userFilters = Filters(
            distance: result['distance'],
            lat: result['lat'],
            lng: result['lng'],
            isComputer: result['isComputer'],
            isPhysical: result['isPhysical'],
            gameDate: null,
            address: result['address']);
        String value = jsonEncode(LoggedInUserInfo.userFilters);

        prefs.setString('defaultValues', value);
      } else {
        LoggedInUserInfo.userFilters = Filters(
            distance: result['distance'],
            lat: result['lat'],
            lng: result['lng'],
            isComputer: result['isComputer'],
            isPhysical: result['isPhysical'],
            gameDate: result['gameDate'],
            address: result['address']);
      }
      Navigator.pushNamed(context, DisplayAvailableGames.routeName);
    } else {
      try {
        final locData = await Location().getLocation();
        double lat = locData.latitude;
        double lng = locData.longitude;
        String address = await LocationHelper.getPlaceAddress(lat, lng);
        Filters filters = Filters(
            lat: lat,
            lng: lng,
            distance: 2,
            isComputer: true,
            isPhysical: true,
            gameDate: null,
            address: address);
        String value = jsonEncode(filters);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('defaultValues', value);
        LoggedInUserInfo.userFilters = Filters(
            distance: 2,
            lat: lat,
            lng: lng,
            isComputer: true,
            isPhysical: true,
            gameDate: null,
            address: address);
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, DisplayAvailableGames.routeName);
      } on PlatformException catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        backgroundColor: Color(0x44000000),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(55, 55, 55, 1),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => ChatScreen()));
        },
        child: Icon(Icons.chat),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Image.asset(_options[_current]['image'], fit: BoxFit.cover),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade50.withOpacity(1),
                      Colors.grey.shade50.withOpacity(0.0),
                      Colors.grey.shade50.withOpacity(0.0),
                      Colors.grey.shade50.withOpacity(0.0),
                      Colors.grey.shade50.withOpacity(0.0),
                    ])),
              ),
            ),
            Positioned(
              bottom: 50,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 500.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.70,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                carouselController: _carouselController,
                items: _options.map(
                  (options) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: 320,
                                  margin: EdgeInsets.only(top: 30),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.asset(
                                      _options[_current]['image'],
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  options['title'],
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                // rating
                                SizedBox(height: 20),
                                Container(
                                  child: Text(
                                    options['description'],
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey.shade600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: _current == _options.indexOf(options)
                                      ? 1.0
                                      : 0.0,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //0. find, 1. add, 2. your games
                                        Container(
                                          margin: EdgeInsets.only(left: 75),
                                          child: _isLoading
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(left: 24),
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : OutlineButton(
                                                  child: Text(options['name']),
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0)),
                                                  onPressed: () async {
                                                    if (_options
                                                            .indexOf(options) ==
                                                        0) {
                                                      await lookForGame();
                                                    }
                                                    if (_options
                                                            .indexOf(options) ==
                                                        1) {
                                                      addGames();
                                                    }
                                                    if (_options
                                                            .indexOf(options) ==
                                                        2) {
                                                      myGames();
                                                    }
                                                    if (_options
                                                            .indexOf(options) ==
                                                        3) {
                                                      gamingHistory();
                                                    }
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
