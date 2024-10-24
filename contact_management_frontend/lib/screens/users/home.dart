import 'package:contact_management_frontend/screens/users/modals/add_contact.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = ApiService().getAllContacts(); // Fetch contacts from the API
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Management System"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // Left Side: Contact List
                Expanded(
                  flex: 3, // Takes up 3/10 of the screen width
                  child: _buildContactList(),
                ),

                // Right Side: Methods Buttons
                Expanded(
                  flex: 7, // Takes up 7/10 of the screen width
                  child: _buildMethodButtons(screenWidth, context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Fetch and display contacts from API
  Widget _buildContactList() {
    return FutureBuilder<List<dynamic>>(
      future: _contactsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load contacts')); // Error
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No contacts found')); // No contacts
        } else {
          final contacts = snapshot.data!;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text('${contact['firstName']} ${contact['lastName']}'),
                subtitle: Text(contact['phone']),
                leading: const Icon(Icons.contact_phone),
                onTap: () {
                  // Handle contact click
                },
              );
            },
          );
        }
      },
    );
  }

  // Method buttons on the right side of the screen
  Widget _buildMethodButtons(double screenWidth, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHomeButton(
            label: "View Contacts",
            onTap: () {
              // Navigate to view contacts page
            },
          ),

          const SizedBox(height: 16.0),

          _buildHomeButton(
            label: "Add Contact",
            onTap: () {
              _showAddContactModal(context);
            },
          ),

          const SizedBox(height: 16.0),

          _buildHomeButton(
            label: "Import Contacts",
            onTap: () {
              // Navigate to import contacts page
            },
          ),

          const SizedBox(height: 16.0),

          _buildHomeButton(
            label: "Export Contacts",
            onTap: () {
              // Navigate to export contacts page
            },
          ),

          const SizedBox(height: 16.0),

          _buildHomeButton(
            label: "Merge Duplicates",
            onTap: () {
              // Navigate to merge duplicates page
            },
          ),
        ],
      ),
    );
  }

  // Reusable method to create home screen buttons
  Widget _buildHomeButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: Text(label),
      ),
    );
  }

  // Function to display the add contact modal
  void _showAddContactModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddContactModal(); // Show the AddContactModal
      },
    );
  }
}
