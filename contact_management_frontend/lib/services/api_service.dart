// ignore_for_file: prefer_const_declarations, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

class ApiService {
  // Function to login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final String apiUrl = '$baseUrl/login'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'User not found'};
      } else if (response.statusCode == 400) {
        return {'success': false, 'message': 'Invalid credentials'};
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (error) {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  // Function to create user
  Future<Map<String, dynamic>> createUser(String username, String email, String password) async {
    final String apiUrl = '$baseUrl/register'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'User created successfully', 'userId': jsonDecode(response.body)['userId']};
      } else if (response.statusCode == 400) {
        return {'success': false, 'message': 'Username already exists'};
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (error) {
      return {'success': false, 'message': 'Error connecting to server'};
    }
  }

  static Future<bool> createContact({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required List<String> tags,
  }) async {
    final String apiUrl = '$baseUrl/create/contact'; // API endpoint

    try {
      final Map<String, dynamic> contactData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'tags': tags,
        'userId': '6719ae4a0c1dce74a7120b90',
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token_here', // Replace with actual token
        },
        body: jsonEncode(contactData),
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Error occurred
      }
    } catch (error) {
      return false; // API error
    }
  }

  Future<List<dynamic>> getAllContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null) {
      throw Exception('No token found');
    }

    // Decode the token to extract user ID
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['userId']; // Assuming the user ID is stored as '_id' in the token payload

    final response = await http.get(
      Uri.parse('$baseUrl/get/all-contacts/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return list of contacts
    } else {
      throw Exception('Failed to fetch contacts');
    }
  }
}
