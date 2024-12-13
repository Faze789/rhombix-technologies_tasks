import 'dart:convert'; // For JSON decoding

import 'package:flutter/material.dart';
import 'package:hospital_app/patient/student_home_screen.dart';
import 'package:http/http.dart' as http;

class check_tours extends StatefulWidget {
  const check_tours({super.key, this.roll_no});

  final roll_no;

  @override
  State<check_tours> createState() => _check_toursState();
}

class _check_toursState extends State<check_tours> {
  List<String> images = [];
  List<String> detailsOfImage = [];

  Future<void> getTourData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:210/home/student/get_tours'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (var item in data) {
        images.add(item['image']);
        detailsOfImage.add(item['tour_image_description']);
      }
    } else {
      throw Exception('Failed to load data');
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
        future: getTourData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          detailsOfImage[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
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
