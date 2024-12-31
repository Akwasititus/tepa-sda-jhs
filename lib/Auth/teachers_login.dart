import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sda/Auth/register.dart';
import 'package:sda/widget/custom_button.dart';
import 'package:sda/widget/custom_textfield.dart';

import '../landing-page/teachers/teachers_landing_page.dart';
import '../widget/custom_dropdown.dart';

class TeachersLoginScreen extends StatefulWidget {
  const TeachersLoginScreen({super.key});

  @override
  State<TeachersLoginScreen> createState() => _TeachersLoginScreenState();
}

class _TeachersLoginScreenState extends State<TeachersLoginScreen> {
  final TextEditingController indexNumberController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;


  Future<void> authenticateUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, return without proceeding
      return;
    }
    final firestore = FirebaseFirestore.instance;
    final indexNumber = indexNumberController.text.trim();
    final level = levelController.text.trim();
    final staffID = indexNumberController.text.trim();


    try {

      setState(() {
        isLoading = true;
      });


      // Check in 'teachers' collection
      final teacherDoc =
      await firestore.collection('teachers').doc(indexNumber).get();

      if (teacherDoc.exists) {
        // Teacher found, navigate to the landing page
        Navigator.push(
          context,
          // MaterialPageRoute(builder: (context) => StudentsListPage(selectedClass: level,)),
          MaterialPageRoute(builder: (context) => TeachersLandingPage(selectedClass: level, staffID: staffID,)),
        );
      }else if(indexNumber.contains("SDA")){
       return;
      }
      else{
        // If no match found, show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Index number not found. Please try again.')),
        );
      }


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  String? validateIndexOrStaffID(String? value) {
    if (value == null || value.isEmpty) {
      return 'Index or Staff Number is required';
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
                      const Text(
                        'TEPA SDA JHS',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF151864),
                        ),
                      ),
                      // School logo
                      Image.asset(
                        'assets/sda.png',
                        height: 200,
                      ),
                      const SizedBox(height: 30),

                      // Title
                      const Text(
                        'Welcome to S.D.A Teachers Portal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF151864), // Dark green to match logo
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        'Enter your Staff Number to Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Text field for index number
                      CustomTextField(
                        hintText: 'Staff ID',
                        controller: indexNumberController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.person,
                        validator: validateIndexOrStaffID,
                      ),
                      const SizedBox(height: 15),
                      CustomDropdown(
                        controller: levelController,
                        prefixIcon: Icons.school,
                        studentLevel: 'Select Student Level',
                        level: const ['JW1', 'JW2', 'JW3', 'JB1', 'JB2', 'JB3', 'EW1', 'EW2', 'EW3'],
                      ),

                      const SizedBox(height: 20),

                      // Login button
                      CustomButton(
                          color: isLoading ? const Color(0xFF151864).withOpacity(0.5) : const Color(0xFF151864),
                          text: isLoading ?  'Logging In...' : 'Login',
                          onPressed: () => authenticateUser(context)
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New Teacher? ',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Sign-Up',
                              style: TextStyle(
                                color: Color(0xFF151864),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
