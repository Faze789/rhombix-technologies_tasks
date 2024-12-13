import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/patient/student_home_screen.dart';
import 'package:http/http.dart' as http;

class select_event extends StatefulWidget {
  const select_event({
    super.key,
    this.registeration_number,
    this.image,
    this.venue,
    this.date,
    this.topic,
    this.price,
    this.time,
  });

  final registeration_number;
  final image;
  final venue;
  final date;
  final topic;
  final price;
  final time;

  @override
  State<select_event> createState() => _select_eventState();
}

class _select_eventState extends State<select_event> {
  @override
  Widget build(BuildContext context) {
    print('---------------');
    print(widget.image);
    print(widget.venue);
    print(widget.date);
    print(widget.topic);
    print(widget.time);

    print('------------------');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic ?? 'Event Details'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.image != null
                  ? Image.network(
                      widget.image!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 100,
                      ),
                    )
                  : const Placeholder(
                      fallbackHeight: 200,
                    ),
              const SizedBox(height: 16),

              // Display the topic
              Text(
                widget.topic ?? 'No topic available',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    widget.venue ?? 'Venue not specified',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    widget.date ?? 'Date not specified',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    widget.time ?? 'Time not specified',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    widget.price ?? 'Free',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  bool check = await add_event(
                    widget.time!,
                    widget.registeration_number,
                    widget.image!,
                    widget.venue!,
                    widget.topic!,
                    widget.price!,
                    widget.date!,
                  );

                  if (check) {
                    // Show a success message and navigate
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Event successfully joined!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => student_home_screen(reg_no: widget.registeration_number)),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not join the event. Please try again.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Center(child: const Text('JOIN THE EVENT ?')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> add_event(String time, String registeration_number, String image, String venue, String topic, String price, String date) async {
    var encode_user_data = jsonEncode({
      "image": image,
      "date": date,
      "price": price,
      "topic": topic,
      "venue": venue,
      "time": time,
      "student_registeration_number": registeration_number,
    });

    final sign_up_api = 'http://10.0.2.2:210/home/student/add_event';

    try {
      final sign_up_post_request = await http.post(
        Uri.parse(sign_up_api),
        headers: {"Content-Type": "application/json"},
        body: encode_user_data,
      );

      if (sign_up_post_request.statusCode == 200) {
        print('EVENT ADDED');
        return true;
      } else {
        print('EVEN could not be added');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
