import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/admin/add_seminars.dart';
import 'package:hospital_app/admin/choose_screen.dart';
import 'package:hospital_app/admin/teachers_data.dart';
import 'package:http/http.dart' as http;

class seminars extends StatefulWidget {
  const seminars({super.key});

  @override
  State<seminars> createState() => _seminarsState();
}

class _seminarsState extends State<seminars> {
  List<String> seminar = [];
  List<String> venue = [];
  List<String> date = [];
  List<String> time = [];
  List<String> image = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        centerTitle: true,
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const add_seminars()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.add)),
          ),
          Center(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const teachers_data()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.screen_lock_landscape)),
          ),
        ],
      ),
      body: FutureBuilder(
        future: gives_doctor_details(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // If data is successfully fetched
            if (image.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: seminar.length,
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
                                seminar[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                venue[index],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 4),
                              Text(
                                'Date: ${date[index]}',
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
              return const Center(child: Text('No doctors available.'));
            }
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Future<String> gives_doctor_details() async {
    final get_doctors_api = 'http://192.168.100.14:210/home/admin/get_doctors_data';

    try {
      final response = await http.get(
        Uri.parse(get_doctors_api),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('Doctors found');
        var data = jsonDecode(response.body);

        seminar.clear();
        venue.clear();
        date.clear();
        time.clear();
        image.clear();

        for (var i in data) {
          seminar.add(i['seminar_name']);
          venue.add(i['venue']);
          date.add(i['date']);
          time.add(i['time']);
          image.add(i['image']);
        }

        return 'success';
      } else {
        print('Doctors could not be found');
        return 'failure';
      }
    } catch (e) {
      print('Error: $e');
      return 'error';
    }
  }
}
