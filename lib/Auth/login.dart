import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sda/Auth/register.dart';
import 'package:sda/Auth/teachers_login.dart';
import 'package:sda/widget/custom_button.dart';
import 'package:sda/widget/custom_textfield.dart';

import '../landing-page/parents/landing_page.dart';
import 'forget_index.dart';
import 'head_teacher_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController indexNumberController = TextEditingController();
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

      final parentDoc =
          await firestore.collection('parents').doc(indexNumber).get();



      if (parentDoc.exists) {
        // Parent found, navigate to the landing page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LandingPage(indexNumber: indexNumber)),
        );

      }else{
        // If no match found, show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Index number not found. Please try again.')),
        );
      }

      // // Check in 'teachers' collection
      // final teacherDoc =
      //     await firestore.collection('teachers').doc(indexNumber).get();
      //
      // if (teacherDoc.exists) {
      //  // Teacher found, navigate to the landing page
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => StudentsListPage(selectedClass: '',)),
      //   );
      // }

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
      return 'Index Number is required';
    }
    if (value.length < 5) {
      return 'Index Number should be at least 5 characters';
    }
    if(!value.contains("TSDA")){
      return 'Invalid Student Number; must be uppercase.';
    }
    if (value.contains('/')) {
      return 'Index Number should not contain "/". Replace it with "-".';
    }
    if (value != value.toUpperCase()) {
      return 'Index Number must be in uppercase.';
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

                        fontWeight: FontWeight.w900,
                        color: Color(0xFF151864), // Dark green to match logo
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
                      'Welcome to Tepa S.D.A School',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF151864), // Dark green to match logo
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      'Enter your Index Number to Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Text field for index number
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: 'Index Number',
                          controller: indexNumberController,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.person,
                          validator: validateIndexOrStaffID,
                        ),
                        Text(
                          '   E.g. TSDA-JHS-24    NOT    TSDA/JHS/24',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotIndexScreen()),
                          );
                        },
                        child: Text(
                          'Forgot Index?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login button
                    CustomButton(
                        color: isLoading ? const Color(0xFF151864).withOpacity(0.5) : const Color(0xFF151864),
                        text: isLoading ?  'Logging in...' : 'Login',
                        onPressed: () => authenticateUser(context)
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New User? ',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100,vertical: 5),
                      child: Divider(),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log-in   ',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TeachersLoginScreen()),
                            );
                          },
                          child: const Text(
                            'As a Teacher',
                            style: TextStyle(
                              color: Color(0xFF151864),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log-in   ',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HeadTeachersLoginScreen()),
                            );
                          },
                          child: const Text(
                            'As a Head Teacher',
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
