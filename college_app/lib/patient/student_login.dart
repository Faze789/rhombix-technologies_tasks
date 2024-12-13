import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/patient/student_home_screen.dart';
import 'package:http/http.dart' as http;

class student_login extends StatelessWidget {
  student_login({super.key});

  var registeration_no;
  var student_name;
  var student_email;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'assets/hanif.png',
              fit: BoxFit.cover,
              width: 200,
              height: 150,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String email = emailController.text;
                      String password = passwordController.text;

                      if (email != null && password != null) {
                        bool check = await sign_in(email, password);
                        if (check) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Person found', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                            ),
                          );
                          print(student_name);
                          print(student_email);
                          print(registeration_no);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => student_home_screen(
                                      reg_no: registeration_no,
                                      student_email: student_email,
                                      student_name: student_name,
                                    )), //
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not found', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> sign_in(String email, String password) async {
    var encode_user_data = jsonEncode({
      "email": email,
      "password": password,
    });

    final sign_in_api = 'http://10.0.2.2:210/home/patient/sign_in';

    final sign_in_post_request = await http.post(Uri.parse(sign_in_api), headers: {"Content-Type": "application/json"}, body: encode_user_data);

    if (sign_in_post_request.statusCode == 200) {
      var responseData = jsonDecode(sign_in_post_request.body);

      registeration_no = responseData['_id'];
      student_name = responseData['name'];
      student_email = responseData['email'];
      print('Person found');

      print('-------------------');
      print(registeration_no);
      print('-------------------');

      return true;
    } else {
      print('Person couldnot be found');

      return false;
    }
  }
}
