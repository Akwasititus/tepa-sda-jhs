import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:sda/widget/custom_button.dart';
import 'package:sda/widget/profile_custom_text_fields.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/custom_dropdown.dart';
import '../models/auth_model.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final String indexNumber;
  const ProfileUpdateScreen({super.key, required this.indexNumber});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  // Image files
  File? parentImage;
  File? childImage;
  late Parent? currentUser;
  final ImagePicker _picker = ImagePicker();

  // Controllers for form fields
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController birthplaceController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController siblingsController = TextEditingController();
  final TextEditingController ghanaCardController = TextEditingController();
  final TextEditingController digitalAddressController =
      TextEditingController();
  final TextEditingController hometownController = TextEditingController();
  final TextEditingController motherLanguageController =
      TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController placeOfStayController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  bool liveWithParents = false;
  bool fatherDeceased = false;
  bool motherDeceased = false;
  bool isLoading = false;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('parents')
        .doc(widget.indexNumber)
        .get();

    if (userDoc.exists) {
      setState(() {
        currentUser = Parent.fromMap(userDoc.data()!);

        // Set the values for each controller to display in the text fields
        parentNameController.text = currentUser!.parentName;
        studentNameController.text = currentUser!.studentName;
        studentIdController.text = currentUser!.indexNumber;
        parentEmailController.text = currentUser!.parentEmail;
        dobController.text = currentUser!.dob;
        birthplaceController.text = currentUser!.birthplace;
        motherNameController.text = currentUser!.motherName;
        fatherNameController.text = currentUser!.fatherName;
        siblingsController.text = currentUser!.siblings;
        ghanaCardController.text = currentUser!.ghanaCardNumber;
        digitalAddressController.text = currentUser!.digitalAddress;
        hometownController.text = currentUser!.hometown;
        motherLanguageController.text = currentUser!.motherLanguage;
        occupationController.text = currentUser!.occupation;
        placeOfStayController.text = currentUser!.placeOfStay;
        levelController.text = currentUser!.level;

        liveWithParents = currentUser!.liveWithParents;
        fatherDeceased = currentUser!.fatherDeceased;
        motherDeceased = currentUser!.motherDeceased;
      });
    }
  }

  Future<void> _pickImage(bool isParent) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isParent) {
          parentImage = File(image.path);
        } else {
          childImage = File(image.path);
        }
      });
    }
  }

  Future<String> _uploadImage(File image, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      String parentImageUrl = '';
      String childImageUrl = '';
      //
      // if (parentImage != null) {
      //   parentImageUrl = await _uploadImage(parentImage!, 'parent_images/${studentIdController.text}');
      // }
      // if (childImage != null) {
      //   childImageUrl = await _uploadImage(childImage!, 'child_images/${studentIdController.text}');
      // }

      final parent = Parent(
        parentEmail: parentEmailController.text,
        parentName: parentNameController.text,
        studentName: studentNameController.text,
        indexNumber: widget.indexNumber,
        level: levelController.text,
        dob: dobController.text,
        birthplace: birthplaceController.text,
        motherName: motherNameController.text,
        fatherName: fatherNameController.text,
        siblings: siblingsController.text,
        ghanaCardNumber: ghanaCardController.text,
        digitalAddress: digitalAddressController.text,
        hometown: hometownController.text,
        motherLanguage: motherLanguageController.text,
        occupation: occupationController.text,
        placeOfStay: placeOfStayController.text,
        liveWithParents: liveWithParents,
        fatherDeceased: fatherDeceased,
        motherDeceased: motherDeceased,
        parentImage: parentImageUrl,
        childImage: childImageUrl,
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

      await firestore
          .collection('parents')
          .doc(studentIdController.text)
          .update(parent.toMap());

      _showUpdateSuccessDialog();
    } catch (e) {
      _showErrorDialog();
    }finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Images Section
            Container(
              color: const Color(0xFF151864),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Parent Image
                      _buildImagePicker(
                        isParent: true,
                        image: parentImage,
                        title: 'Parent Photo',
                      ),
                      // Child Image
                      _buildImagePicker(
                        isParent: false,
                        image: childImage,
                        title: 'Student Photo',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form Sections
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Basic Information'),
                    ProfileCustomTextField(
                      label: "parent Name",
                      controller: parentNameController,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Student Name',
                      controller: studentNameController,
                      prefixIcon: Icons.person_outline,
                    ),
                    // const SizedBox(height: 15),
                    // ProfileCustomTextField(
                    //   label: widget.indexNumber,
                    //   controller: studentIdController,
                    //   prefixIcon: Icons.badge,
                    // ),
                    const SizedBox(height: 15),
                    CustomDropdown(
                      controller: levelController,
                      prefixIcon: Icons.school,
                      studentLevel: levelController.text,
                      level: const ['JW1', 'JW2', 'JW3', 'JB1', 'JB2', 'JB3', 'EW1', 'EW2', 'EW3'],
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Parent Email',
                      controller: parentEmailController,
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 30),
                    _buildSectionTitle('Personal Information'),
                    // Date of Birth
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2024),
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF151864),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            dobController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: ProfileCustomTextField(
                          label: 'Date of Birth',
                          controller: dobController,
                          prefixIcon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Place of Birth',
                      controller: birthplaceController,
                      prefixIcon: Icons.location_city,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Ghana Card Number',
                      controller: ghanaCardController,
                      prefixIcon: Icons.credit_card,
                    ),

                    const SizedBox(height: 30),
                    _buildSectionTitle('Family Information'),
                    ProfileCustomTextField(
                      label: "Mother's Name",
                      controller: motherNameController,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: "Father's Name",
                      controller: fatherNameController,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Number of Siblings',
                      controller: siblingsController,
                      prefixIcon: Icons.people,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    _buildSwitchTile(
                      'Do you live with your children?',
                      liveWithParents,
                      (value) => setState(() => liveWithParents = value),
                    ),
                    _buildSwitchTile(
                      'Is father deceased?',
                      fatherDeceased,
                      (value) => setState(() => fatherDeceased = value),
                    ),
                    _buildSwitchTile(
                      'Is mother deceased?',
                      motherDeceased,
                      (value) => setState(() => motherDeceased = value),
                    ),

                    const SizedBox(height: 30),
                    _buildSectionTitle('Location & Additional Information'),
                    ProfileCustomTextField(
                      label: 'Digital Address',
                      controller: digitalAddressController,
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Hometown',
                      controller: hometownController,
                      prefixIcon: Icons.home,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Mother Language',
                      controller: motherLanguageController,
                      prefixIcon: Icons.language,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Occupation',
                      controller: occupationController,
                      prefixIcon: Icons.work,
                    ),
                    const SizedBox(height: 15),
                    ProfileCustomTextField(
                      label: 'Place of Stay',
                      controller: placeOfStayController,
                      prefixIcon: Icons.house,
                    ),

                    const SizedBox(height: 30),
                    CustomButton(
                      text: isLoading ? 'profile updating...': 'Update Profile',
                      onPressed: () {
                        // Implement update logic
                        _updateUserProfile();

                      }, color: isLoading ? const Color(0xFF151864).withOpacity(0.5) : const Color(0xFF151864),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required bool isParent,
    required File? image,
    required String title,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(isParent),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(60),
              border: Border.all(color: Colors.white, width: 3),
              image: image != null
                  ? DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: image == null
                ? const Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: Color(0xFF151864),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF151864),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF151864),
        ),
      ),
    );
  }

  void _showUpdateSuccessDialog() {
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
                'Profile Updated!',
                style: TextStyle(
                  color: Color(0xFF151864),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your profile information has been successfully updated.',
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



  void _showErrorDialog() {
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
                Icons.close,
                color: Colors.red,
                size: 60,
              ),
              SizedBox(height: 15),
              Text(
                'Profile Updated Error!',
                style: TextStyle(
                  color: Color(0xFF151864),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'There was an error updating your profile. Please try again later',
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
