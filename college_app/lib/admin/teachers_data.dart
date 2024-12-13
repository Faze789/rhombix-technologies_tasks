import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/admin/add_teachers.dart';
import 'package:hospital_app/admin/choose_screen.dart';
import 'package:http/http.dart' as http;

class teachers_data extends StatefulWidget {
  const teachers_data({super.key});

  @override
  State<teachers_data> createState() => _teachers_dataState();
}

class _teachers_dataState extends State<teachers_data> {
  List<String> teacher_name = [];
  List<String> teacher_profession = [];
  List<String> teacher_education = [];
  List<String> teacher_experience = [];
  List<String> image = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers Data'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => choose_screen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          Center(
            child: IconButton(
              onPressed: () {
                get_teachers_data();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const add_teachers()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: get_teachers_data(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data == 'success') {
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: teacher_name.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(image[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              teacher_name[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teacher_profession[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teacher_education[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Experience: ${teacher_experience[index]}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No teachers found'));
          }
        },
      ),
    );
  }

  Future<String> get_teachers_data() async {
    final get_teachers_api = 'http://192.168.100.14:210/home/admin/get_teachers_data';

    try {
      final response = await http.get(
        Uri.parse(get_teachers_api),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        teacher_name.clear();
        teacher_education.clear();
        teacher_experience.clear();
        teacher_profession.clear();
        image.clear();

        for (var i in data) {
          teacher_name.add(i['teacher_name']);
          teacher_education.add(i['education']);
          teacher_experience.add(i['experience']);
          teacher_profession.add(i['profession']);
          image.add(i['image']);
        }

        return 'success';
      } else {
        print('Teachers could not be found');
        return 'failure';
      }
    } catch (e) {
      print('Error: $e');
      return 'error';
    }
  }
}
