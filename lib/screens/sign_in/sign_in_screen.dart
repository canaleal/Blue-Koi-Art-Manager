
import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/screens/home/home.dart';
import 'package:flutter_test_bed/screens/widgets/google_sign_in_button.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:connectivity/connectivity.dart';
import 'component/no_account_text.dart';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_bed/infrastructure/firebase/authentication.dart';
import 'package:flutter_test_bed/screens/widgets/validator.dart';
import 'package:flutter_test_bed/screens/widgets/fire_auth.dart';


import 'dart:async';

import 'package:flutter_test_bed/constants.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Variables used to check the connectivity status
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {

    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      result = ConnectivityResult.none;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  // Set connectivity result value
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    String finalResult = '';
    switch (result) {
      case ConnectivityResult.wifi:
        finalResult = 'Wifi Connection';
        break;
      case ConnectivityResult.mobile:
        finalResult = 'Mobile Connection';
        break;
      case ConnectivityResult.none:
        finalResult = 'No Connection';
        break;

      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
    setState(() => _connectionStatus = finalResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 100.0),
                  const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  SignForm(),
                  SizedBox(height: 16.0),
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return GoogleSignInButton();
                      }
                      return CircularProgressIndicator(
                       
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  const NoAccountText(),
                ],
              ),
            )),
      ),
    );
  }
}

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 16.0),
                buildEmailFormField(),
                SizedBox(height: 8.0),
                buildPasswordFormField(),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Checkbox(
                      value: remember,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          remember = value;
                        });
                      },
                    ),
                    Text("Remember me"),
                    Spacer(),
                    GestureDetector(
                      onTap: () => {},
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.0),
                _isProcessing
                    ? CircularProgressIndicator()
                    : DefaultButton(
                        text: "Login",
                        press: () async {
                          _focusEmail.unfocus();
                          _focusPassword.unfocus();

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });

                            User? user =
                                await FireAuth.signInUsingEmailPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );

                            setState(() {
                              _isProcessing = false;
                            });

                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Home(user: user),
                                ),
                              );
                            }
                          }
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _passwordTextController,
      focusNode: _focusPassword,
      obscureText: true,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) => Validator.validatePassword(
        password: value,
      ),
      decoration: InputDecoration(
        hintText: "Password",
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(

      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      controller: _emailTextController,
      focusNode: _focusEmail,
      validator: (value) => Validator.validateEmail(
        email: value,
      ),
      decoration: InputDecoration(
        hintText: "Email",
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
