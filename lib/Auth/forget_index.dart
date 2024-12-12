import 'package:flutter/material.dart';
import 'package:sda/widget/custom_button.dart';
import 'package:sda/widget/custom_textfield.dart';

import '../widget/custom_dropdown.dart';

class ForgotIndexScreen extends StatelessWidget {
  ForgotIndexScreen({super.key});

  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF005f2d),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Forgot Password Icon
              Icon(
                Icons.lock_reset,
                size: 100,
                color: const Color(0xFF151864).withOpacity(0.8),
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                'Forgot Index Number?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF151864),
                ),
              ),
              const SizedBox(height: 15),

              // Subtitle
              Text(
                'Please fill in your details below and we\'ll help you recover your index number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // Parent Name Field
              CustomTextField(
                hintText: 'Parent Name',
                controller: parentNameController,
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 15),

              // Student Name Field
              CustomTextField(
                hintText: 'Student Name',
                controller: studentNameController,
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 15),

              // Date of Birth Field
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2010),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF005f2d),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    dobController.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    hintText: 'Student Date of Birth',
                    controller: dobController,
                    keyboardType: TextInputType.none,
                    prefixIcon: Icons.calendar_today,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Student Level Field
              // CustomTextField(
              //   hintText: 'Student Level (e.g., JHS 1)',
              //   controller: levelController,
              //   keyboardType: TextInputType.text,
              //   prefixIcon: Icons.school,
              // ),

              CustomDropdown(
                controller: levelController,
                prefixIcon: Icons.school,
                studentLevel: 'Select Student Level',
                level: const ['JW1', 'JW2', 'JW3', 'JB1', 'JB2', 'JB3', 'EW1', 'EW2', 'EW3'],
              ),
              const SizedBox(height: 30),

              // Submit Button
              CustomButton(
                color: const Color(0xFF151864),
                text: 'Submit Request',
                onPressed: () {
                  // Implement your submit logic here
                  _showSuccessDialog(context);
                },
              ),
              const SizedBox(height: 20),

              // Back to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember your index? ',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login here',
                      style: TextStyle(
                        color: Color(0xFF151864),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Color(0xFF151864),
                size: 60,
              ),
              SizedBox(height: 15),
              Text(
                'Request Submitted!',
                style: TextStyle(
                  color: Color(0xFF151864),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your request has been submitted successfully. The school authorities will review your information and contact you soon.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF151864),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

