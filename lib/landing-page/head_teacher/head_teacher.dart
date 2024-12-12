import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sda/landing-page/head_teacher/teachers_details.dart';
import '../../models/auth_teacher_model.dart';

class HeadTeacherDashboard extends StatefulWidget {
   const HeadTeacherDashboard({super.key});

  @override
  _HeadTeacherDashboardState createState() => _HeadTeacherDashboardState();
}

class _HeadTeacherDashboardState extends State<HeadTeacherDashboard> {
  List<Teacher> teachers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('teachers').get();

      setState(() {
        teachers = querySnapshot.docs
            .map((doc) => Teacher.fromMap(doc.data()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load teachers'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF151864),
        title: const Text(
          'Head Teacher Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:
      isLoading ?
           const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF151864),
              ),
            )
          :
        ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF151864).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF151864),
                      ),
                    ),
                    title: Text(
                      teacher.teacherName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF151864),
                      ),
                    ),
                    subtitle: Text(
                      teacher.teacherEmail,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: teacher.isHeadTeacher
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("You"),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(teacher.level),
                          ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherDetailsPage(teacher: teacher),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF151864),
        onPressed: () => _showCreateAnnouncementBottomSheet(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showCreateAnnouncementBottomSheet(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    File? imageFile;
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                imageFile = File(pickedFile.path);
              });
            }
          }

          Future<void> createAnnouncement() async {
            if (titleController.text.isEmpty ||
                descriptionController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(

                const SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }

            try {
              String? imageUrl;
              if (imageFile != null) {
                final storageRef = FirebaseStorage.instance.ref().child(
                    'announcements/${DateTime.now().millisecondsSinceEpoch}');
                await storageRef.putFile(imageFile!);
                imageUrl = await storageRef.getDownloadURL();
              }

              await FirebaseFirestore.instance.collection('announcements').add({
                'title': titleController.text.trim(),
                'description': descriptionController.text.trim(),
                'imageUrl': imageUrl ?? 'assets/sda.png',
                'timestamp': FieldValue.serverTimestamp(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Announcement sent successful')),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to create announcement: $e')),
              );
            }
          }

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Announcement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF151864),
                  ),
                ),
                const SizedBox(height: 20),
                imageFile != null
                    ? Image.file(imageFile!, height: 150, fit: BoxFit.cover)
                    : ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        label: const Text('Pick Image',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF151864),
                        ),
                      ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: createAnnouncement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151864),
                  ),
                  child: const Text(
                    'Create Announcement',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}






