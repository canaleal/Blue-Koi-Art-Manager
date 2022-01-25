
import 'package:flutter/material.dart';
import 'package:flutter_test_bed/screens/sign_up/register_screen.dart';



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
                builder: (context) => const SignUpScreen(

                ),
              ),
            );
          },
          child: const Text(
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