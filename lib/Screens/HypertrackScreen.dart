// ignore_for_file: deprecated_member_use

import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:hypertrack_plugin/hypertrack.dart';

import 'package:share/share.dart';

import 'NetworkHelper.dart';

const String publishableKey =
    'Ro8hBKgwULgkKwUtSKZn3kEJKoxKPDLwr5cSfirDJAypdlYZZC5IkGotnSMDrWIoBZEOjXjZkyE9Jiy2IkT7-g';
void main() => runApp(HyperTrackQuickStart());

class HyperTrackQuickStart extends StatefulWidget {
  HyperTrackQuickStart({Key key}) : super(key: key);
  static const routeName = "/HypertrackScreen";

  @override
  _HyperTrackQuickStartState createState() => _HyperTrackQuickStartState();
}

class _HyperTrackQuickStartState extends State<HyperTrackQuickStart> {
  HyperTrack sdk;
  String deviceId;
  NetworkHelper helper;
  String result = '';
  bool isLink = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    sdk = await HyperTrack.initialize(publishableKey);
    deviceId = await sdk.getDeviceId();
    sdk.setDeviceName(LoggedInUserInfo.name);
    helper = NetworkHelper(
        url: 'https://v3.api.hypertrack.com',
        auth:
            'Basic aF9PTXBYYU5ZXzF3djhfX19VRVh5dzRmb3dvOl9YRDVCRVM3Z3hFZUNvbHp6a08wUmNPV0ZkTGVTZ3pnTVpWd3JzOHpFSEE0dm1YTE9UeWRfZw==',
        id: deviceId);
    print(deviceId);
  }

  void shareLink() async {
    setState(() {
      isLoading = true;
      result = '';
    });
    var data = await helper.getData();
    print(data);
    setState(() {
      result = data['views']['share_url'];
      isLink = true;
      isLoading = false;
    });
    Share.share(data['views']['share_url'], subject: 'USER NAME\'s Location');
  }

  void startTracking() async {
    setState(() {
      isLoading = true;
      result = '';
    });
    var startTrack = await helper.startTracing();
    setState(() {
      result = (startTrack['message']);
      isLink = false;
      isLoading = false;
    });
  }

  void endTracking() async {
    setState(() {
      isLoading = true;
      result = '';
    });
    var endTrack = await helper.endTracing();
    setState(() {
      result = (endTrack['message']);
      isLink = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(1, 1, 1, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 0.0,
            width: double.infinity,
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading ? CircularProgressIndicator() : Text(''),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  result,
                  style: TextStyle(
                    color: isLink ? accentColor : Colors.red[900],
                    fontFamily: 'Raleway',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            child: Text(
              'Start Tracking my Location',
            ),
            onPressed: startTracking,
          ),
          FlatButton(
            child: Text('Share my Location'),
            onPressed: shareLink,
          ),
          FlatButton(
            child: Text('End Tracking my Location'),
            onPressed: endTracking,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
