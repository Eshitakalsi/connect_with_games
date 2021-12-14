// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/Helpers/location_helper.dart';
import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'map_screen.dart';

class AddGame extends StatefulWidget {
  static const routeName = "/AddGame";

  @override
  _AddGameState createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  var _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();
  String gameName = "";
  int selectedRadioTile = 1;
  double lat;
  double lng;
  double maxDistanceRadius;
  DateTime playingTime;

  static final _formkey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  String address;
  void _updateAddress(String add) {
    setState(() {
      address = add;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (address == null) {
      address = '';
    }
    if (!_formkey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formkey.currentState.save();

    try {
      int totalGamesRequests = 0;
      await FirebaseFirestore.instance
          .collection('Games')
          .where('userId', isEqualTo: LoggedInUserInfo.id)
          .get()
          .then((value) {
        totalGamesRequests = value.docs.length;
      });
      if (totalGamesRequests >= 2) {
        print("Cannot Add this Data");
        throw Exception();
      }
      List<String> splitList = gameName.split(" ");
      List<String> indexList = [];
      for (int i = 0; i < splitList.length; i++) {
        for (int j = 1; j <= splitList[i].length; j++) {
          indexList.add(splitList[i].substring(0, j).toLowerCase());
        }
      }
      await FirebaseFirestore.instance.collection('Games').add({
        'gameName': gameName,
        'gameType': selectedRadioTile == 1 ? 'Physical' : 'Computer',
        'userId': LoggedInUserInfo.id,
        'userName': LoggedInUserInfo.name,
        'latitude': lat,
        'longitude': lng,
        'distanceRange': maxDistanceRadius,
        'playDate': playingTime,
        'searchindex': indexList,
        'joinedUsers': [],
        'requestedUsers': []
      });

      setState(() {
        _isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Game added successfully!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Cannot add any more games!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      lat = locData.latitude;
      lng = locData.longitude;
      final address = await LocationHelper.getPlaceAddress(
          locData.latitude, locData.longitude);
      _updateAddress(address);
      _controller.text = address;
    } on PlatformException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  Future<void> _selectOnMap() async {
    try {
      final locData = await Location().getLocation();
      final lt = locData.latitude;
      final lg = locData.longitude;
      final address = await LocationHelper.getPlaceAddress(
          lat == null ? lt : lat, lng == null ? lg : lng);
      final selectedLocation = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => MapScreen(
                  lat == null ? lt : lat, lng == null ? lg : lng, address)));
      if (selectedLocation == null) {
        return;
      } else {
        lat = selectedLocation[0];
        lng = selectedLocation[1];
        final address = await LocationHelper.getPlaceAddress(
            selectedLocation[0], selectedLocation[1]);
        _updateAddress(address);
        _controller.text = address;
      }
    } on PlatformException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  void setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Add Your Game'),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(1, 1, 1, 1),
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          elevation: 0,
        ),
        body: Card(
          margin: EdgeInsets.all(10),
          elevation: 20,
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 130),
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      maxLength: 15,
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter atleast 3 characters.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        gameName = val;
                      },
                      decoration: InputDecoration(
                        labelText: "Game Name",
                      ),
                    ),
                    RadioListTile(
                        value: 1,
                        groupValue: selectedRadioTile,
                        title: Text("Physical"),
                        selected: false,
                        activeColor: accentColor,
                        onChanged: (val) {
                          setSelectedRadioTile(val);
                        }),
                    RadioListTile(
                        value: 2,
                        groupValue: selectedRadioTile,
                        title: Text("Computer"),
                        selected: false,
                        activeColor: accentColor,
                        onChanged: (val) {
                          setSelectedRadioTile(val);
                        }),
                    if (selectedRadioTile == 1)
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              OutlineButton.icon(
                                borderSide: BorderSide(color: accentColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                icon: Icon(Icons.map),
                                label: Text("Select on Map"),
                                onPressed: () {
                                  _selectOnMap();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              OutlineButton.icon(
                                borderSide: BorderSide(color: accentColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                icon: Icon(Icons.location_on),
                                label: Text("Current Location"),
                                onPressed: () {
                                  _getCurrentUserLocation();
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: 'Place',
                              errorText: address == ''
                                  ? 'Please Enter a Location'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.length <= 0) {
                                return "Please Enter Distance";
                              }
                              if (double.parse(value) < 0 ||
                                  double.parse(value) > 12756) {
                                return "Please Enter a Valid Distance";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              maxDistanceRadius = double.parse(val);
                            },
                            decoration: InputDecoration(
                              labelText: "Within Distance (KM)",
                            ),
                          )
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DateTimeField(
                            decoration: InputDecoration(
                              labelText: 'Playing Date & Time',
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please Enter a Date';
                              }
                              playingTime = value;
                              return null;
                            },
                            onSaved: (value) {
                              playingTime = value;
                            },
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    _isLoading == true
                        ? CircularProgressIndicator()
                        : OutlineButton(
                            borderSide: BorderSide(color: accentColor),
                            child: Text("Submit"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blueAccent)),
                            onPressed: () {
                              _submit();
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
