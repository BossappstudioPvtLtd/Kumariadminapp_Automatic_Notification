import 'package:flutter/material.dart';

class MyForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const MyForm({required this.titleController, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(
          controller: titleController,
          labelText: 'Title',
        ),
        const SizedBox(height: 10),
        buildTextField(
          controller: descriptionController,
          labelText: 'Description',
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white30,
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
