// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../common/action_button.dart';
import '../../common/constants.dart';
import '../../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService(); // Instantiate ApiService

  Future<void> _createUser() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _apiService.createUser(username, email, password);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/background_contactmanagement_auth.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Sign-up form
          Center(
            child: Padding(
              padding: EdgeInsets.all(
                  size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
              child: Card(
                elevation: 8,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: size.height *
                      (size.height > 770
                          ? 0.7
                          : size.height > 670
                              ? 0.8
                              : 0.9),
                  width: size.width > 600 ? 500 : size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Less transparent
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              color: kPrimaryColor,
                              thickness: 2,
                              endIndent: 100,
                              indent: 100,
                            ),
                            const SizedBox(height: 32),
                            // Name TextField
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                labelText: 'Username',
                                suffixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Email TextField
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                labelText: 'Email',
                                suffixIcon: Icon(Icons.mail_outline),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Password TextField
                            TextField(
                              controller: _passwordController,
                              obscureText: true, // Hide the password
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                suffixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                            const SizedBox(height: 64),
                            _isLoading
                                ? const CircularProgressIndicator() 
                                : GestureDetector(onTap: _createUser, child: actionButton("Create Account")),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Log In",
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: kPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
