// CustomTextField Widget
import 'package:flutter/material.dart';
class ProfileCustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const ProfileCustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF151864),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF151864),
            width: 2,
          ),
        ),
      ),
    );
  }
}