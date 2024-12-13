import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/admin/choose_screen.dart';
import 'package:http/http.dart' as http;

class admin_Login extends StatelessWidget {
  const admin_Login({super.key});

  @override
  Widget build(BuildContext context) {
    // TextEditingControllers for email and password
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
                  // Email Text Field
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
                      print('Email: ${emailController.text}');
                      print('Password: ${passwordController.text}');

                      String email = emailController.text;
                      String password = passwordController.text;

                      if (email != null && password != null) {
                        bool check = await admin_sign_in(email, password);
                        if (check) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('DOCTOR FOUND', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => choose_screen()),
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

  Future<bool> admin_sign_in(String email, String password) async {
    var encode_user_data = jsonEncode({
      "email": email,
      "password": password,
    });

    final sign_up_api = 'http://192.168.100.14:210/home/admin/sign_in';

    try {
      final sign_up_post_request = await http.post(
        Uri.parse(sign_up_api),
        headers: {"Content-Type": "application/json"},
        body: encode_user_data,
      );

      print(email);
      print(password);

      if (sign_up_post_request.statusCode == 200) {
        print('Person found');
        return true;
      } else {
        print('Person could not be found');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
