import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spring/function.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = '';
  String data = '';
  var decoded;
  String output = 'Output';
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Spring App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Spring',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'This is the home page',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  setState(() {
                    url = 'http://127.0.0.1:5000/api?query=${value.toString()}';
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Value',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    data = await fetchdata(url);
                    decoded = jsonDecode(data);
                    setState(() {
                      output = decoded['ascii'];
                    });
                  } catch (e) {
                    setState(() {
                      output = 'Error: $e';
                    });
                  }
                },
                child: const Text('Fetch ASCII value of a character'),
              ),
              const SizedBox(height: 16),
              Text(
                output,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactDialog(context);
          },
          child: const Icon(Icons.contact_mail),
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Us'),
          content: const Column(
            children: [
              ListTile(
                title: Text('Rahul Deoghare'),
                subtitle: Text('LinkedIn'),
              ),
              ListTile(
                title: Text('Yatharth Wazir'),
                subtitle: Text('LinkedIn'),
              ),
              // Add more developer details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(Home());
}
