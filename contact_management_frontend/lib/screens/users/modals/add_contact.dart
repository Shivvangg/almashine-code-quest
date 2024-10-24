// ignore_for_file:library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../services/api_service.dart';

class AddContactModal extends StatefulWidget {
  const AddContactModal({super.key});

  @override
  _AddContactModalState createState() => _AddContactModalState();
}

class _AddContactModalState extends State<AddContactModal> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Contact'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(labelText: 'Tags (comma-separated)'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _addContact();
          },
          child: const Text('Add Contact'),
        ),
      ],
    );
  }

  void _addContact() async {
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String email = emailController.text;
    final String phone = phoneController.text;
    final String tags = tagsController.text;

    bool success = await ApiService.createContact(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      tags: tags.split(',').map((tag) => tag.trim()).toList(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add contact')),
      );
    }

    Navigator.of(context).pop(); 
  }
}
