// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:connect_with_games/Models/loggedInUserInfo.dart';
import 'package:connect_with_games/Pickers/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_with_games/Screens/NewWelcomeScreen.dart';
import 'package:connect_with_games/commons/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class IntermediateMainScreen extends StatefulWidget {
  static const routeName = "/UserInformation";
  final String _uid;
  final String _email;
  final String _phoneNo;
  IntermediateMainScreen(this._uid, this._email, this._phoneNo);

  @override
  _IntermediateMainScreenState createState() => _IntermediateMainScreenState();
}

class _IntermediateMainScreenState extends State<IntermediateMainScreen> {
  bool _hasUserDataAlready = false;
  var _isLoading = false;
  static final _formKey = GlobalKey<FormState>();
  var _firstname = ' ';
  var _lastname = ' ';
  var imageURL = '';
  int selectedRadioTile = 1;
  File _userImageFile;
  void _pickedImage(PickedFile image) {
    _userImageFile = File(image.path);
  }

  void setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Future<void> _submitUserInformation(
      String firstName, String lastName, File image, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(widget._uid + '.jpg');
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      imageURL = url;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget._uid)
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'image_url': url,
        'gender': selectedRadioTile == 1 ? 'Male' : 'Female',
      });
      setState(() {
        _isLoading = false;
        _hasUserDataAlready = true;
      });
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } on HttpException catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "Please check your Internet Connection",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _trySubmit() {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (_userImageFile == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      if (isValid) {
        _formKey.currentState.save();
        _submitUserInformation(
            _firstname.trim(), _lastname.trim(), _userImageFile, context);
      } else {
        return;
      }
    }

    Widget userInfoForm = Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/four.jpeg'),
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
                Colors.black.withOpacity(.3),
              ],
            ),
          ),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 5,
              margin: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserImagePicker(_pickedImage),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'FirstName'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your First Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _firstname = value;
                          },
                          key: ValueKey('firstName'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'LastName'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your Last Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _lastname = value;
                          },
                          key: ValueKey('lastName'),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          children: [
                            RadioListTile(
                                value: 1,
                                groupValue: selectedRadioTile,
                                title: Text("Male"),
                                selected: false,
                                activeColor: accentColor,
                                onChanged: (val) {
                                  setSelectedRadioTile(val);
                                }),
                            RadioListTile(
                                value: 2,
                                groupValue: selectedRadioTile,
                                title: Text("Female"),
                                selected: false,
                                activeColor: accentColor,
                                onChanged: (val) {
                                  setSelectedRadioTile(val);
                                }),
                          ],
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                clipBehavior: Clip.hardEdge,
                                color: Colors.black,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                                onPressed: () {
                                  _trySubmit();
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (_hasUserDataAlready) {
      LoggedInUserInfo.id = widget._uid;
      LoggedInUserInfo.name = _firstname;
      LoggedInUserInfo.url = imageURL;
      LoggedInUserInfo.email = widget._email;
      LoggedInUserInfo.phoneNo = widget._phoneNo;
      LoggedInUserInfo.gender = selectedRadioTile == 1 ? 'Male' : 'Female';
      return NewWelcomeScreen();
    } else {
      return userInfoForm;
    }
  }
}
