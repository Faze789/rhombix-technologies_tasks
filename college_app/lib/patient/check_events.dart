import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/patient/notifier_student.dart';
import 'package:hospital_app/patient/select_event.dart';
import 'package:hospital_app/patient/student_home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CheckEvents extends StatelessWidget {
  CheckEvents({super.key, this.reg_no});
  final reg_no;

  final List<String> images = [];
  final List<String> seminarNames = [];
  final List<String> venues = [];
  final List<String> dates = [];
  final List<String> times = [];
  // final List<int> price = [];

  Future<void> fetchEvents() async {
    const String apiUrl = 'http://10.0.2.2:210/home/student/get_events_data';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        images.clear();
        seminarNames.clear();
        venues.clear();
        dates.clear();
        times.clear();
        // price.clear();

        for (int i = 0; i < data.length; i++) {
          images.add(data[i]['image']);
          seminarNames.add(data[i]['seminar_name']);
          venues.add(data[i]['venue']);
          dates.add(data[i]['date']);
          times.add(data[i]['time']);
          // price.add(10 + (i * 10));
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => student_home_screen(
                        reg_no: reg_no,
                      )),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(reg_no!),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<void>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (images.isEmpty) {
            return const Center(child: Text('No events available.'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8,
              ),
              itemCount: seminarNames.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    notifier_student n1 = notifier_student();
                    print('333333');
                    print(n1.prices[index]);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => select_event(
                                registeration_number: reg_no,
                                image: images[index],
                                date: dates[index],
                                venue: venues[index],
                                time: times[index],
                                topic: seminarNames[index],
                                price: n1.prices[index].toString(),
                              )),
                      (route) => false,
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                images[index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    seminarNames[index],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Venue: ${venues[index]}',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Date: ${dates[index]}',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Time`: ${times[index]}',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Consumer<notifier_student>(
                                        builder: (context, notifier, child) {
                                          return Text(
                                            'Price: \$${notifier.prices[index]}',
                                            style: const TextStyle(fontSize: 12, color: Colors.green),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
