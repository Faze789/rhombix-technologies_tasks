import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/patient/student_home_screen.dart';
import 'package:http/http.dart' as http;

class check_teachers extends StatefulWidget {
  const check_teachers({super.key, this.roll_no});

  final roll_no;

  @override
  State<check_teachers> createState() => _check_teachersState();
}

class _check_teachersState extends State<check_teachers> {
  List<String> images = [];
  List<String> teacherNames = [];
  List<String> professions = [];
  List<String> educations = [];
  List<String> experiences = [];

  Future<void> fetchTeachers() async {
    const String apiUrl = 'http://10.0.2.2:210/home/student/get_teachers';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (var item in data) {
          images.add(item['image']);
          teacherNames.add(item['teacher_name']);
          professions.add(item['profession']);
          educations.add(item['education']);
          experiences.add(item['experience']);
        }
      } else {
        throw Exception('Failed to fetch data.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roll_no),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => student_home_screen(reg_no: widget.roll_no)),
                (route) => false,
              );
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder<void>(
        future: fetchTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.75,
              ),
              itemCount: teacherNames.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          images[index],
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacherNames[index],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              professions[index],
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Edu: ${educations[index]}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Exp: ${experiences[index]}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
