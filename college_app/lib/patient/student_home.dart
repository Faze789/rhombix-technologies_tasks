import 'package:flutter/material.dart';
import 'package:hospital_app/patient/student_login.dart';
import 'package:hospital_app/patient/student_sign_up.dart';

class student_home extends StatelessWidget {
  const student_home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => student_login()),
                      (route) => false,
                    );
                  },
                  child: Center(
                      child: Text(
                    'login',
                    style: style(Colors.red),
                  )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => patient_SignUp()),
                      (route) => false,
                    );
                  },
                  child: Center(
                      child: Text(
                    'Sign up',
                    style: style(Colors.blue),
                  )),
                ),
              ],
            )
          ],
        ));
  }

  TextStyle style(Color color) {
    return TextStyle(
      fontSize: 20,
      color: color,
    );
  }
}
