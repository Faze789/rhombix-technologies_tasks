import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/admin/campus_tour.dart';
import 'package:hospital_app/admin/notifier_admin.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class add_tour_pics extends StatefulWidget {
  const add_tour_pics({super.key});

  @override
  State<add_tour_pics> createState() => _add_tour_picsState();
}

class _add_tour_picsState extends State<add_tour_pics> {
  // Controller for the TextField
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget builderIcon(notifier_admin provider) {
      if (provider.selectedImage != null) {
        if (kIsWeb) {
          return Image.network(
            provider.selectedImage!.path,
            width: 200,
            height: 200,
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
        title: const Text('Add Tour Pics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<notifier_admin>(builder: (context, provider, child) {
              return IconButton(
                onPressed: () {
                  provider.open_gallery();
                },
                icon: builderIcon(provider),
              );
            }),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description of Image',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final provider = Provider.of<notifier_admin>(context, listen: false);

                  bool check = await tour_data_add(provider.imageUrl ?? 'UNKNWON', _descriptionController.text);

                  if (check) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tours data added successfully!', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => campus_tour()), // new route to navigate to
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tour data couldnot be added ', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('SUBMIT'))
          ],
        ),
      ),
    );
  }

  Future<bool> tour_data_add(String image, String tour_image_details) async {
    var encode_user_data = jsonEncode({
      "image": image,
      "tour_image_description": tour_image_details,
    });

    final sign_up_api = 'http://127.0.0.1:210/home/admin/tours/add_tours_data';

    try {
      final sign_up_post_request = await http.post(
        Uri.parse(sign_up_api),
        headers: {"Content-Type": "application/json"},
        body: encode_user_data,
      );

      if (sign_up_post_request.statusCode == 200) {
        print('Added tour data ');
        return true;
      } else {
        print('Couldnot add tour data');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
