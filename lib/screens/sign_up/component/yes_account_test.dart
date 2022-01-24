import 'package:flutter/material.dart';
import 'package:flutter_test_bed/screens/sign_in/sign_in_screen.dart';


class YesAccountText extends StatelessWidget {
  const YesAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an Account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignInScreen(

                ),
              ),
            );
          },
          child: Text(
            "Login",
            style: TextStyle(
                fontSize: 16,
                color: Colors.blue),
          ),
        ),
      ],
    );
  }
}