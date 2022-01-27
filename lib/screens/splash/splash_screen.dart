import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_test_bed/size_config.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'images/main_logo.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    const Text(
                      'BlueKoi Art Manager',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    const Text(
                      'Processing with Machine Learning',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(40)),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
