import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/admin/choose_screen.dart';
import 'package:hospital_app/admin/notifier_admin.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class add_seminars extends StatefulWidget {
  const add_seminars({super.key});

  @override
  State<add_seminars> createState() => _nameState();
}

class _nameState extends State<add_seminars> {
  // TextEditingControllers for each text field
  final TextEditingController seminar_name = TextEditingController();
  final TextEditingController venue_name = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget builderIcon(notifier_admin provider) {
      if (provider.selectedImage != null) {
        if (kIsWeb) {
          return Image.network(
            provider.selectedImage!.path,
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          );
        } else {
          return Image.file(
            File(provider.selectedImage!.path),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          );
        }
      } else {
        return const Icon(Icons.add_a_photo);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Seminars'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<notifier_admin>(
              builder: (context, provider, child) {
                return IconButton(
                  onPressed: () {
                    provider.open_gallery();
                  },
                  icon: builderIcon(provider),
                );
              },
            ),
            TextField(
              controller: seminar_name,
              decoration: const InputDecoration(
                hintText: 'Enter Seminar Name',
                labelText: 'Seminar Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: venue_name,
              decoration: const InputDecoration(
                hintText: 'Enter Venue',
                labelText: 'Venue',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: date,
              decoration: const InputDecoration(
                hintText: 'Enter Date',
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: time,
              decoration: const InputDecoration(
                hintText: 'Enter time',
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String seminar = seminar_name.text;
                String venue = venue_name.text;
                String date_ = date.text;
                String time_ = time.text;

                final provider = Provider.of<notifier_admin>(context, listen: false);

                bool check = await add_doctor(provider.imageUrl ?? 'unknown', seminar, venue, date_, time_);

                if (check) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Doctor added successfully!', style: TextStyle(color: Colors.white)),
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
                      content: Text('Failed to add doctor.', style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> add_doctor(String image, String seminar, String venue, String date_, String time_) async {
    var encode_user_data = jsonEncode({
      "image": image,
      "seminar_name": seminar,
      "venue": venue,
      "date": date_,
      "time": time_,
    });

    print('--------------');
    final sign_up_api = 'http://127.0.0.1:210/home/admin/sign_in/add_doctors';

    try {
      final sign_up_post_request = await http.post(
        Uri.parse(sign_up_api),
        headers: {"Content-Type": "application/json"},
        body: encode_user_data,
      );

      if (sign_up_post_request.statusCode == 200) {
        print('added data');
        return true;
      } else {
        print('couldnot add data');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
