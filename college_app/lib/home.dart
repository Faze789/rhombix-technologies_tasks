import 'package:flutter/material.dart';
import 'package:hospital_app/admin/admin_login.dart';
import 'package:hospital_app/patient/student_home.dart';

class home extends StatelessWidget {
  const home({super.key});

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
                      MaterialPageRoute(builder: (ctx) => student_home()),
                      (route) => false,
                    );
                  },
                  child: Center(
                      child: Text(
                    'Student',
                    style: style(Colors.red),
                  )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => admin_Login()),
                      (route) => false,
                    );
                  },
                  child: Center(
                      child: Text(
                    'ADMIN',
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
