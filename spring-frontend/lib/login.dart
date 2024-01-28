import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Here you can add your logic for authentication
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Dummy authentication example
    if (username == 'admin' && password == 'password') {
      // Navigate to dashboard or another screen upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      // Show error message for invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _login,
          child: const Text('Login'),
        ),
      ],
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
      ),
      body: Center(
        child: const Text('Welcome to Dashboard!'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Login Demo',
    home: LoginPage(),
  ));
}
