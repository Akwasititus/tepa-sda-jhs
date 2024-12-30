import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sda/Auth/register.dart';
import 'package:sda/widget/custom_button.dart';
import 'package:sda/widget/custom_textfield.dart';

import '../widget/custom_dropdown.dart';
import '../landing-page/head_teacher/head_teacher.dart';
import '../landing-page/teachers/teachers.dart';

class HeadTeachersLoginScreen extends StatefulWidget {
  const HeadTeachersLoginScreen({super.key});

  @override
  State<HeadTeachersLoginScreen> createState() => _HeadTeachersLoginScreenState();
}

class _HeadTeachersLoginScreenState extends State<HeadTeachersLoginScreen> {
  final TextEditingController indexNumberController = TextEditingController();
  // final TextEditingController levelController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> authenticateUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, return without proceeding
      return;
    }
    final firestore = FirebaseFirestore.instance;
    final indexNumber = indexNumberController.text.trim();

    try {
      setState(() {
        isLoading = true;
      });

      // Check in 'teachers' collection
      final teacherDoc =
      await firestore.collection('teachers').doc(indexNumber).get();

      if (teacherDoc.exists) {
        // Teacher found, navigate to the landing page
        final isHeadTeacher = teacherDoc.data()?['isHeadTeacher'] ?? false;

        if (isHeadTeacher) {
          // Navigate to second page for Head Teacher
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HeadTeacherDashboard()),
          );
        } else {
          // If not a head teacher, show error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access denied. Only Head Teacher can log in.'),
            ),
          );
        }
      } else {
        // If no match found, show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Index number not found. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String? validateIndexOrStaffID(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID Number is required';
    }
    if (value.length < 5) {
      return 'Staff Number should be at least 5 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // School logo
                      Image.asset(
                        'assets/sda.png',
                        height: 200,
                      ),
                      const SizedBox(height: 30),

                      // Title
                      const Text(
                        'Welcome, Mr Head Master',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF151864), // Dark green to match logo
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        'Please enter your ID',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Text field for index number
                      CustomTextField(
                        hintText: 'Enter your ID here',
                        controller: indexNumberController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.person,
                        validator: validateIndexOrStaffID,
                      ),

                      const SizedBox(height: 20),

                      // Login button
                      CustomButton(
                          color: isLoading ? const Color(0xFF151864).withOpacity(0.5) : const Color(0xFF151864),
                          text: isLoading ?  'Sending...' : 'Send',
                          onPressed: () => authenticateUser(context)
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child:
                const Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFF151864),
                            strokeWidth: 5,
                          ),
                        )),
                  ),
                ),
              ),
          ]
      ),
    );
  }
}
