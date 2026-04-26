import 'package:flutter/material.dart';
import '../controllers/crud_services.dart';

class UpdateContactPage extends StatefulWidget {
  final String docId;
  final String name;
  final String phone;

  const UpdateContactPage({
    super.key, 
    required this.docId, 
    required this.name, 
    required this.phone
  });

  @override
  State<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends State<UpdateContactPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await CRUDService().updateContact(
                  widget.docId, 
                  _nameController.text, 
                  _phoneController.text
                );
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}