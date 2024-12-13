import 'dart:convert'; // For JSON decoding

import 'package:flutter/material.dart';
import 'package:hospital_app/admin/add_tour_pics.dart';
import 'package:hospital_app/admin/choose_screen.dart';
import 'package:http/http.dart' as http;

class campus_tour extends StatefulWidget {
  const campus_tour({super.key});

  @override
  State<campus_tour> createState() => _campus_tourState();
}

class _campus_tourState extends State<campus_tour> {
  // Lists to hold data
  List<String> images = [];
  List<String> details_of_image = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const choose_screen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const add_tour_pics()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: get_tour_data(),
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
                          details_of_image[index],
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

  Future<void> get_tour_data() async {
    final response = await http.get(Uri.parse('http://192.168.100.14:210/home/admin/tours/get_tour_data'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (var item in data) {
        images.add(item['image']);
        details_of_image.add(item['tour_image_description']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
