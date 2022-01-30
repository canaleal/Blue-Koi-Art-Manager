import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/screens/home/home.dart';
import 'package:flutter_test_bed/screens/widgets/validator.dart';
import 'package:flutter_test_bed/screens/widgets/fire_auth.dart';
import 'package:flutter_test_bed/constants.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'component/yes_account_test.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


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
                  SizedBox(height: getProportionateScreenHeight(100)),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height: 8.0),
                  const Text(
                    "Sign up with your name, email and password",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
     
                  const SignForm(),


                  SizedBox(height: getProportionateScreenHeight(20)),
                  const YesAccountText(),
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
  final _registerFormKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? password;
  bool? remember = false;


  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
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
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(20),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _registerFormKey,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                

                buildNameFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildEmailFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildPasswordFormField(),

                SizedBox(height: getProportionateScreenHeight(20)),



                _isProcessing
                    ? const CircularProgressIndicator()
                    : DefaultButton(
                  text: "Sign Up",
                  press: () async {
                    setState(() {
                      _isProcessing = true;
                    });

                    if (_registerFormKey.currentState!
                        .validate()) {
                      User? user = await FireAuth
                          .registerUsingEmailPassword(
                        name: _nameTextController.text,
                        email: _emailTextController.text,
                        password:
                        _passwordTextController.text,
                      );

                      setState(() {
                        _isProcessing = false;
                      });

                      if (user != null) {
                        Navigator.of(context)
                            .pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(user: user),
                          )

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



  TextFormField buildNameFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      controller: _nameTextController,
      focusNode: _focusName,
      validator: (value) => Validator.validateName(
        name: value,
      ),
      decoration: InputDecoration(
        hintText: "Name",
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


