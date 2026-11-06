// OWNER: Member 2  (Login + Sign up in one screen, toggled with _isLogin)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/courses.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_header.dart';
import '../widgets/app_text_field.dart';
import '../widgets/info_banner.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();

  bool _isLogin = true;
  bool _loading = false;
  String? _error;
  String? _course;
  String? _year;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toggle() => setState(() {
    _isLogin = !_isLogin;
    _error = null;
  });

  String _friendly(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-email':
        return "That email and password don't match. Check your details and try again.";
      case 'email-already-in-use':
        return 'An account with that email already exists. Try logging in.';
      case 'weak-password':
        return 'Enter a password with at least 8 characters.';
      case 'network-request-failed':
        return 'No internet connection. Check your network and try again.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_isLogin) {
        await _auth.signIn(_email.text, _password.text);
      } else {
        await _auth.signUp(
          name: _name.text,
          email: _email.text,
          course: _course!,
          year: _year!,
          password: _password.text,
        );
      }
      // Success: main.dart's auth gate switches to the app automatically.
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = _friendly(e));
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (_email.text.trim().isEmpty) {
      setState(
        () => _error = 'Type your email above first, then tap Forgot password.',
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _auth.resetPassword(_email.text);
      messenger.showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = _friendly(e));
    }
  }

  Widget _loginHero() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(size: 64),
          SizedBox(height: 8),
          Text(
            'StudyMate',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLogin) ...[
                  const AppHeader(showMenu: false),
                  const SizedBox(height: 16),
                  _loginHero(),
                  const SizedBox(height: 16),
                  const Text(
                    'Better together.',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Welcome back. Your next study breakthrough starts here.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ] else ...[
                  const AppHeader(showMenu: false),
                  const SizedBox(height: 16),
                  const Text(
                    'JOIN YOUR CAMPUS',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Text(
                    'Find your people.',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "A little about you. We'll help you find the right people to learn with.",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
                const SizedBox(height: 20),
                if (!_isLogin)
                  AppTextField(
                    label: 'Full name',
                    controller: _name,
                    icon: Icons.person_outline,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter your name'
                        : null,
                  ),
                AppTextField(
                  label: 'University email',
                  controller: _email,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter a valid email'
                      : null,
                ),
                if (!_isLogin) ...[
                  AppDropdown(
                    label: 'Course',
                    hint: 'Select your course',
                    items: asItems(kCourses),
                    value: _course,
                    onChanged: (v) => setState(() => _course = v),
                    validator: (v) => v == null ? 'Select your course' : null,
                  ),
                  AppDropdown(
                    label: 'Year of study',
                    hint: 'Select your year',
                    items: asItems(kYears),
                    value: _year,
                    onChanged: (v) => setState(() => _year = v),
                    validator: (v) => v == null ? 'Select your year' : null,
                  ),
                ],
                AppTextField(
                  label: 'Password',
                  controller: _password,
                  isPassword: true,
                  hint: _isLogin ? null : 'Create a password',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (!_isLogin && v.length < 8) {
                      return 'Enter a password with at least 8 characters.';
                    }
                    return null;
                  },
                ),
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: const Text('Forgot password?'),
                    ),
                  ),
                if (_error != null) InfoBanner(message: _error!, isError: true),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(_isLogin ? 'Log in' : 'Create account'),
                ),
                const SizedBox(height: 14),
                Center(
                  child: TextButton(
                    onPressed: _toggle,
                    child: Text(
                      _isLogin
                          ? 'New to StudyMate? Sign up'
                          : 'Already part of the group? Log in',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
