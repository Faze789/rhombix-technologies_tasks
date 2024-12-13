import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/patient/check_events.dart';
import 'package:hospital_app/patient/check_teachers.dart';
import 'package:hospital_app/patient/check_tours.dart';
import 'package:http/http.dart' as http;

class student_home_screen extends StatefulWidget {
  final reg_no;
  final student_name;
  final student_email;

  const student_home_screen({
    super.key,
    this.reg_no,
    this.student_name,
    this.student_email,
  });

  @override
  State<student_home_screen> createState() => _student_home_screenState();
}

class _student_home_screenState extends State<student_home_screen> {
  List<String> images = [];
  List<String> venues = [];
  List<String> times = [];
  List<String> prices = [];
  List<String> topics = [];
  List<String> dates = [];

  Future<bool> get_student_events() async {
    var encode_user_data = jsonEncode({
      "student_id": widget.reg_no,
    });

    print('--------------');
    print(widget.reg_no);
    print('------------');
    final sign_in_api = 'http://10.0.2.2:210/home/student_get_events';

    final sign_in_post_request = await http.post(
      Uri.parse(sign_in_api),
      headers: {"Content-Type": "application/json"},
      body: encode_user_data,
    );

    if (sign_in_post_request.statusCode == 200) {
      var responseData = jsonDecode(sign_in_post_request.body);

      List<dynamic> events = responseData;

      for (var event in events) {
        images.add(event['image']);
        venues.add(event['venue']);
        times.add(event['time']);
        prices.add(event['price']);
        topics.add(event['topic']);
        dates.add(event['date']);
      }

      print('Images: $images');
      print('Venues: $venues');
      print('Times: $times');
      print('Prices: $prices');
      print('Topics: $topics');
      print('Dates: $dates');

      print('Events found');
      return true;
    } else {
      print('Events could not be found');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(92, 83, 109, 254),
      appBar: AppBar(
        title: Text(widget.reg_no),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reg_no ?? 'REG. No',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        widget.student_name ?? 'NAME',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        widget.student_email ?? 'EMAIL',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => CheckEvents(reg_no: widget.reg_no!)),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 130,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/events.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'CHECK EVENTS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => check_tours(roll_no: widget.reg_no)),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 130,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/tour.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'College Tour',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => check_teachers(roll_no: widget.reg_no)),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 130,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/teachers.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'See Teachers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FutureBuilder<bool>(
                future: get_student_events(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching events');
                  } else if (snapshot.data == false || images.isEmpty) {
                    return const Text('No events found');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(topics[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Venue: ${venues[index]}'),
                                Text('Date: ${dates[index]}'),
                                Text('Time: ${times[index]}'),
                                Text('Price: ${prices[index]}'),
                              ],
                            ),
                            leading: Image.network(
                              images[index],
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
