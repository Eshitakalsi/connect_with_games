// ignore_for_file: deprecated_member_use, duplicate_ignore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const routeName = "/PhoneAuthentication";
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  var _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final _formkey = GlobalKey<FormState>();
  String _phoneNo;
  final _codeController = TextEditingController();

  Future<void> _verifyPhoneNo(String phoneNo, BuildContext context) async {
    final _isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isValid) {
      return;
    }
    _formkey.currentState.save();
    final PhoneVerificationCompleted verified =
        (AuthCredential credential) async {
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.of(context).pop();
        Navigator.pop(context);
      } on PlatformException catch (err) {
        var message = 'An error occured!!';
        if (err.message != null) {
          message = err.message;
        }
        _scaffoldKey.currentState.hideCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } on FirebaseAuthException catch (err) {
        var message = 'An error occured!!';
        if (err.message != null) {
          message = err.message;
        }
        _scaffoldKey.currentState.hideCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } catch (err) {
        _scaffoldKey.currentState.hideCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Something went wrong. Please try again!",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            authException.message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Please enter the verification code!',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(192, 178, 131, 1),
              ),
            ),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[TextField(controller: _codeController)]),
            actions: <Widget>[
              FlatButton(
                child: Text("Confirm"),
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () async {
                  try {
                    AuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verId,
                        smsCode: _codeController.text.trim());

                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  } catch (err) {
                    _scaffoldKey.currentState.hideCurrentSnackBar();

                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          err.message,
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Theme.of(context).errorColor));
                  }
                },
              ),
            ],
          );
        },
      );
    };
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: null);
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured!!';
      if (err.message != null) {
        message = err.message;
      }
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.hideCurrentSnackBar();

      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.hideCurrentSnackBar();

      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Something went wrong. Please try again!",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/three.jpeg'),
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
              color: Color.fromRGBO(55, 55, 55, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 5,
              margin: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Login with Phone',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          width: double.infinity,
                        ),
                        TextFormField(
                          style: TextStyle(
                              color: Color.fromRGBO(192, 178, 131, 1)),
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(192, 178, 131, 1),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (val) {
                            _phoneNo = val;
                          },
                          validator: (val) {
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            // ignore: deprecated_member_use
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  _verifyPhoneNo(
                                      _phoneNo == null ? '' : _phoneNo.trim(),
                                      context);
                                },
                              )
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
  }
}
