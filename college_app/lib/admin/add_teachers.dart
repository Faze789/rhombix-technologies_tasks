import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/admin/notifier_admin.dart';
import 'package:hospital_app/admin/teachers_data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class add_teachers extends StatefulWidget {
  const add_teachers({super.key});

  @override
  State<add_teachers> createState() => _nameState();
}

class _nameState extends State<add_teachers> {
  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    teacherNameController.dispose();
    professionController.dispose();
    educationController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void submitForm() async {
    final provider = Provider.of<notifier_admin>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      print(provider.imageUrl);
      print('Teacher Name: ${teacherNameController.text}');
      print('Profession: ${professionController.text}');
      print('Education: ${educationController.text}');
      print('Experience: ${experienceController.text}');

      bool check = await add_doctor_data(
        provider.imageUrl ?? 'unknown',
        teacherNameController.text,
        professionController.text,
        educationController.text,
        experienceController.text,
      );

      if (check) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Teacher added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => teachers_data()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not add teacher!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        title: const Text('Add Teacher'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Consumer<notifier_admin>(builder: (context, provider, child) {
                return IconButton(
                  onPressed: () {
                    provider.open_gallery();
                  },
                  icon: builderIcon(provider),
                );
              }),
              // Teacher Name Text Field
              TextFormField(
                controller: teacherNameController,
                decoration: const InputDecoration(
                  labelText: 'Teacher Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the teacher name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: professionController,
                decoration: const InputDecoration(
                  labelText: 'Profession',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the profession';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: educationController,
                decoration: const InputDecoration(
                  labelText: 'Education',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the education';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: experienceController,
                decoration: const InputDecoration(
                  labelText: 'Experience',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the experience';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> add_doctor_data(String image, String teacher_name, String profession, String education, String experience) async {
    var encode_user_data = jsonEncode({
      "image": image,
      "teacher_name": teacher_name,
      "profession": profession,
      "education": education,
      "experience": experience,
    });

    print('--------------');
    final sign_up_api = 'http://127.0.0.1:210/home/admin/sign_in/add_teachers';

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
