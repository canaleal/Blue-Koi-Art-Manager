
import 'package:flutter/material.dart';
import 'package:flutter_test_bed/screens/sign_up/sign_up_screen.dart';
import 'package:flutter_test_bed/screens/splash/splash_screen.dart';



class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignUpScreen(

                ),
              ),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 16,
                color: Colors.blue),
          ),
        ),
      ],
    );
  }
}