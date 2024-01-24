import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spring/function.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = '';
  String data = '';
  var decoded;
  String output = 'Output';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Spring',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'This is the home page',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    url = 'http://127.0.0.1:4000/api?query=${value.toString()}';
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Value',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () async {
                    try {
                      data = await fetchdata(url);
                      decoded = jsonDecode(data);
                      setState(() {
                        output = decoded['ascii'];
                      });
                    } catch (e) {
                      // Handle any exceptions that occurred during data fetching.
                      // print('Error: $e');
                      setState(() {
                        output = 'Error: $e';
                      });
                    }
                  },
                  child: const Text('Fetch ASCII value of a character')),
              const SizedBox(height: 16),
              Text(output),
              // const Text("Hello"),
            ],
          ),
        ),
      ),
    );
  }
}
