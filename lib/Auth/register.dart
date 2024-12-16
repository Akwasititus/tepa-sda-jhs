import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sda/Auth/teachers_login.dart';
import 'package:sda/widget/custom_button.dart';
import 'package:sda/widget/custom_role_selector.dart';
import 'package:sda/widget/custom_textfield.dart';

import '../models/auth_teacher_model.dart';
import '../widget/custom_dropdown.dart';
import '../models/auth_model.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// parents controllers
  final TextEditingController parentEmailController = TextEditingController();
  final TextEditingController indexNumberController = TextEditingController();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  /// teachers controllers
  final TextEditingController teachersEmailController = TextEditingController();
  final TextEditingController teachersNameController = TextEditingController();
  final TextEditingController teachersStaffIDController =
      TextEditingController();
  final TextEditingController teachersProfessionalQualificationController =
      TextEditingController();
  final TextEditingController teachersGhanaCardController =
      TextEditingController();
  final TextEditingController teachersLicencesController =
      TextEditingController();
  final TextEditingController teachersPhoneContactController =
      TextEditingController();
  final TextEditingController teachersPrevSchoolController =
      TextEditingController();
  final TextEditingController teachersGenderController =
      TextEditingController();
  final TextEditingController teachersMaritalStatusController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedRole = 'Parent';
  bool isLoading = false;

  void registerUser() async {
    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, return without proceeding
      return;
    }
    final firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    try {
      if (selectedRole == 'Parent') {
        final parent = Parent(
          parentEmail: parentEmailController.text,
          parentName: parentNameController.text,
          studentName: studentNameController.text,
          indexNumber: indexNumberController.text,
          level: levelController.text,
          dob: '',
          birthplace: '',
          ghanaCardNumber: '',
          motherName: '',
          fatherName: '',
          siblings: '',
          digitalAddress: '',
          hometown: '',
          motherLanguage: '',
          occupation: '',
          placeOfStay: '',
          liveWithParents: false,
          fatherDeceased: false,
          motherDeceased: false,
          parentImage: '',
          childImage: '',
          classRoomBehavior: 'Excellent',
          classRoomParticipation: 'Very Active',
          homeworkCompletion: '91',
          math: 0.85,
          science: 0.43,
          english: 0.40,
          social: 0.92,
          averageGrade: 'A+',
          classRank: '3rd',
          attendance: '93',
        );

        // Use indexNumber as the document ID
        final docRef = firestore.collection('parents').doc(parent.indexNumber);

        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          // Parent already exists
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Student with this index number already exists')),
          );
        } else {
          // Add new parent to Firestore
          await docRef.set(parent.toMap());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student registered successfully')),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        final teacher = Teacher(
          teacherEmail: teachersEmailController.text,
          teacherName: teachersNameController.text,
          staffID: teachersStaffIDController.text,
          isHeadTeacher: false,
          level: levelController.text,
          professionalQualification:
              teachersProfessionalQualificationController.text,
          ghanaCardNumber: teachersGhanaCardController.text,
          licenseNumber: teachersLicencesController.text,
          phoneContact: teachersPhoneContactController.text,
          previousSchoolAttended: teachersPrevSchoolController.text,
          gender: teachersGenderController.text,
          maritalStatus: teachersMaritalStatusController.text,
        );

        // Use staffID as the document ID
        final docRef = firestore.collection('teachers').doc(teacher.staffID);

        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          // Teacher already exists
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Teacher with this staff ID already exists')),
          );
        } else {
          // Add new teacher to Firestore
          await docRef.set(teacher.toMap());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Teacher registered successfully')),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TeachersLoginScreen()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering user: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateIndexOrStaffID(String? value) {
    if (value == null || value.isEmpty) {
      return 'Index Number is required';
    }
    if (value.length < 5) {
      return 'Index Number should be at least 5 characters';
    }
    if (!value.contains("TSDA")) {
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

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // School logo
                    Image.asset(
                      'assets/sda.png', // Add your logo in assets and specify path here
                      height: 120,
                    ),
                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      'Create New Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF151864),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'You have selected to register as a ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              selectedRole,
                              style: const TextStyle(
                                fontSize: 16,
                                backgroundColor: Color(0xFF151864),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                    const SizedBox(height: 30),

                    CustomRoleSelector(
                      selectedRole: selectedRole,
                      onRoleSelected: (String role) {
                        setState(() {
                          selectedRole = role;
                          // Clear fields when role changes
                          if (role == 'Teacher') {
                            parentNameController.clear();
                            studentNameController.clear();
                            indexNumberController.clear();
                          }
                        });
                      },
                    ),
                    Text(
                      "Please indicate if you are a 'Parent' or 'Teacher' ",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 15),

                    if (selectedRole == 'Parent') ...[
                      // Parent Email
                      CustomTextField(
                        hintText: 'Parent Email',
                        controller: parentEmailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 15),

                      // Student Index Number
                      CustomTextField(
                        hintText: 'Student Index Number',
                        controller: indexNumberController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.numbers,
                        validator: validateIndexOrStaffID,
                      ),
                      const SizedBox(height: 15),

                      // Parent Name
                      CustomTextField(
                        hintText: 'Parent Name',
                        controller: parentNameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),

                      // Student Name
                      CustomTextField(
                        hintText: 'Student Name',
                        controller: studentNameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomDropdown(
                        controller: levelController,
                        prefixIcon: Icons.school,
                        studentLevel: 'Select Student Level',
                        level: const [
                          'JW1',
                          'JW2',
                          'JW3',
                          'JB1',
                          'JB2',
                          'JB3',
                          'EW1',
                          'EW2',
                          'EW3'
                        ],
                      ),

                      const SizedBox(height: 20),
                    ] else ...[
                      CustomTextField(
                        hintText: 'Teachers Staff ID',
                        controller: teachersStaffIDController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.numbers,
                        // validator: validateIndexOrStaffID,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Teachers Name',
                        controller: teachersNameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Teachers Email',
                        controller: teachersEmailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Professional Qualification',
                        controller: teachersProfessionalQualificationController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.document_scanner_outlined,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Ghana card No.',
                        controller: teachersGhanaCardController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.insert_drive_file_outlined,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Teachers License No.',
                        controller: teachersLicencesController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.ac_unit,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Phone Contact',
                        controller: teachersPhoneContactController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.phone,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Previous school attended',
                        controller: teachersPrevSchoolController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.man_sharp,
                        validator: validateName,
                      ),
                      const SizedBox(height: 15),
                      CustomDropdown(
                        controller: teachersGenderController,
                        prefixIcon: Icons.male,
                        studentLevel: 'Gender',
                        level: const ['Male', 'Female'],
                      ),
                      const SizedBox(height: 15),
                      CustomDropdown(
                        controller: teachersMaritalStatusController,
                        prefixIcon: Icons.margin_outlined,
                        studentLevel: 'Marital Status',
                        level: const ['Single', 'Marriage'],
                      ),
                      const SizedBox(height: 15),
                      CustomDropdown(
                        controller: levelController,
                        prefixIcon: Icons.school,
                        studentLevel: 'Select Student Level',
                        level: const [
                          'JW1',
                          'JW2',
                          'JW3',
                          'JB1',
                          'JB2',
                          'JB3',
                          'EW1',
                          'EW2',
                          'EW3'
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Register button
                    CustomButton(
                      color: isLoading
                          ? const Color(0xFF151864).withOpacity(0.5)
                          : const Color(0xFF151864),
                      text: isLoading ? 'Registering...' : 'Register',
                      onPressed: registerUser,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Login',
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
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
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
      ]),
    );
  }
}
