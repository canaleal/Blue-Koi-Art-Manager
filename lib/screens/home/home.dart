import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/components/form_error.dart';
import 'package:flutter_test_bed/infrastructure/firebase/authentication.dart';
import 'package:flutter_test_bed/screens/gallery/gallery.dart';
import 'package:flutter_test_bed/screens/home/component/sign_out_button.dart';
import 'package:flutter_test_bed/screens/home/search_form.dart';
import 'package:flutter_test_bed/screens/splash/splash_screen.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late User user;
  bool _isSigningOut = false;

  @override
  void initState() {
    user = widget._user;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(10),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(20)),
                    const Text(
                      "Search a Category",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    SearchForm(user: user),
                    SizedBox(height: getProportionateScreenHeight(200)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _isSigningOut //Signing Out Button
                                ? const CircularProgressIndicator(
                                    //shows progress along a circle while signing out
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors
                                            .white), //Animation for single color
                                  )
                                : SignOutButton(
                                    text: "Sign Out",
                                    icon: "assets/icons/Question mark.svg",
                                    press: () async {
                                      setState(() {
                                        //checking the state
                                        _isSigningOut = true;
                                      });
                                      await Authentication.signOut(
                                          context: context);
                                      setState(() {
                                        _isSigningOut = false;
                                      });
                                      Navigator.of(context).pushReplacement(
                                        //Navigate to Sign In Screen
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SplashScreen(),
                                        ),
                                      );
                                    },
                                  ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
