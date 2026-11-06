// OWNER: Member 1
// PLACEHOLDER: only a bare login form so everyone can sign in while testing.
// Member 1: replace this with the full Login + Sign up screens from Figma.
// Keep the class name AuthScreen (main.dart uses it).
// Until sign up exists, create test users in Firebase console:
// Authentication > Users > Add user.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  Future<void> _login() async {
    try {
      await AuthService().signIn(_email.text, _password.text);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login (placeholder - Member 1)',
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              TextField(
                  controller: _email,
                  decoration: const InputDecoration(hintText: 'Email')),
              const SizedBox(height: 10),
              TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password')),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _login, child: const Text('Log in')),
            ],
          ),
        ),
      ),
    );
  }
}
