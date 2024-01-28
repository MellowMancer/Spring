import 'package:flutter/material.dart';
import 'dashboard.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: const Center(
//         child: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: LoginForm(),
//         ),
//       ),
//     );
//   }
// }

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  static const String routeName = '/login';

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          child: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Material(
          child: TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}

// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Dashboard'),
//       ),
//       body: const Center(
//         child: Text('Welcome to Dashboard!'),
//       ),
//     );
//   }
// }