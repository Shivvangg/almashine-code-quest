// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, sized_box_for_whitespace, unused_element

import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/action_button.dart';
import '../../services/api_service.dart';
import '../../common/constants.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService(); // Instantiate ApiService

  // Login function that uses ApiService and SharedPreferences
  Future<void> _loginUser() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await _apiService.loginUser(email, password);

    if (response['success']) {
      final String token =
          response['data']['token']; 
      // Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // String userId = decodedToken['userId']; 
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      Navigator.pushReplacementNamed(context, '/home');
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
          // Login form
          Center(
            child: Padding(
              padding: EdgeInsets.all(size.height > 770
                  ? 64
                  : size.height > 670
                      ? 32
                      : 16),
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
                              "LOG IN",
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
                                ? const CircularProgressIndicator() // Show a loading spinner if the request is in progress
                                : GestureDetector(
                                    onTap: _loginUser,
                                    child: actionButton("Log In")),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "You do not have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/signup');
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Sign Up",
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
