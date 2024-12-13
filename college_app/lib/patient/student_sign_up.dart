import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class patient_SignUp extends StatelessWidget {
  const patient_SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    // TextEditingControllers for name, email, and password
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
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
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () async {
                      String name = nameController.text;
                      String email = emailController.text;
                      String password = passwordController.text;

                      if (name != null && email != null && password != null) {
                        bool check = await add_patient(name, email, password);
                        if (check) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Person just added', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not add person', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> add_patient(String email, String password, String name) async {
    var encode_user_data = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    });

    final sign_up_api = 'http://10.0.2.2:210/home/add_patient';

    final sign_up_post_request = await http.post(Uri.parse(sign_up_api), headers: {"Content-Type": "application/json"}, body: encode_user_data);

    print(sign_up_post_request.body);

    if (sign_up_post_request.statusCode == 200) {
      print('login credientials just added');

      return true;
    } else {
      print('login credientials exists');

      return false;
    }
  }
}
