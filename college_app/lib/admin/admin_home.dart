import 'package:flutter/material.dart';
import 'package:hospital_app/admin/admin_login.dart';

class admin_home_dart extends StatelessWidget {
  const admin_home_dart({super.key});

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
                      MaterialPageRoute(builder: (ctx) => admin_Login()),
                      (route) => false,
                    );
                  },
                  child: Center(
                      child: Text(
                    'login',
                    style: style(Colors.red),
                  )),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).pushAndRemoveUntil(
                //       MaterialPageRoute(builder: (ctx) => SignUp()),
                //       (route) => false,
                //     );
                //   },
                //   child: Center(
                //       child: Text(
                //     'Sign up',
                //     style: style(Colors.blue),
                //   )),
                // ),
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
