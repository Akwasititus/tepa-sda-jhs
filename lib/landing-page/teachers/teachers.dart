import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sda/landing-page/teachers/teacher_student_details.dart';
import '../../models/auth_model.dart';
import 'package:intl/intl.dart';

import 'date.dart';

class StudentsListPage extends StatefulWidget {
  final String selectedClass;

  const StudentsListPage({super.key, required this.selectedClass});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  Color _getRandomColor(String name) {
    final List<Color> colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.white10
    ];
    return colors[name.length % colors.length];
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quizLinkController = TextEditingController();
  DateTime? _deadline;

  void _submitForm() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String quizLink = _quizLinkController.text.trim();


    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('quizzes').add({
        'title': title,
        'level': widget.selectedClass,
        'description': description,
        'deadline': _deadline,
        'quizLink': quizLink,
        // 'updatedAt':  FieldValue.serverTimestamp()
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
            content: Text('Quiz added successfully!')),
      );
      Navigator.of(context).pop();
      _clearFormFields();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to add quiz: $error')),
      );
    } finally {
      setState(() {
        isLoading =
            false; // Ensure isLoading is reset regardless of success or failure
      });
    }
  }

  void _clearFormFields() {
    _titleController.clear();
    _descriptionController.clear();
    _quizLinkController.clear();
    setState(() {
      _deadline = null;
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    void showAddQuizForm() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bottom sheet handle
                  Center(
                    child: Container(
                      width: 70,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Title of the bottom sheet
                  Text(
                    'Create A New Quiz',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Title TextField with custom decoration
                  _buildTextField(
                    controller: _titleController,
                    labelText: 'Title',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 15),

                  // Description TextField with custom decoration
                  _buildTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 15),

                  // Quiz Link TextField with custom decoration
                  _buildTextField(
                    controller: _quizLinkController,
                    labelText: 'Quiz Link',
                    icon: Icons.link,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 20.1),

                  // Deadline selection row
                  const Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Color(0xFF151864)),
                      SizedBox(width: 11),
                      DeadlineSelector(),

                    ],
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF151864),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      isLoading ? "Submitting..." : "Submit Quiz",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      );
    }


    // void showAddQuizForm() {
    //   showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(
    //         top: Radius.circular(25),
    //       ),
    //     ),
    //     backgroundColor: Colors.white,
    //     builder: (BuildContext context) {
    //       return Container(
    //         padding: EdgeInsets.only(
    //           bottom: MediaQuery.of(context).viewInsets.bottom,
    //           top: 20,
    //           left: 20,
    //           right: 20,
    //         ),
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               // Bottom sheet handle
    //               Center(
    //                 child: Container(
    //                   width: 70,
    //                   height: 5,
    //                   margin: const EdgeInsets.only(bottom: 20),
    //                   decoration: BoxDecoration(
    //                     color: Colors.grey[300],
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                 ),
    //               ),
    //
    //               // Title of the bottom sheet
    //               Text(
    //                 'Create A New Quiz',
    //                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black87,
    //                 ),
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 20),
    //
    //               // Title TextField with custom decoration
    //               _buildTextField(
    //                 controller: _titleController,
    //                 labelText: 'Title',
    //                 icon: Icons.title,
    //               ),
    //               const SizedBox(height: 15),
    //
    //               // Description TextField with custom decoration
    //               _buildTextField(
    //                 controller: _descriptionController,
    //                 labelText: 'Description',
    //                 icon: Icons.description,
    //                 maxLines: 3,
    //               ),
    //               const SizedBox(height: 15),
    //
    //               // Quiz Link TextField with custom decoration
    //               _buildTextField(
    //                 controller: _quizLinkController,
    //                 labelText: 'Quiz Link',
    //                 icon: Icons.link,
    //                 keyboardType: TextInputType.url,
    //               ),
    //               const SizedBox(height: 20),
    //
    //               // Deadline selection row
    //               Row(
    //                 children: [
    //                   const Icon(Icons.calendar_today,
    //                       color: Color(0xFF151864)),
    //                   Expanded(child: Container()),
    //                   const SizedBox(width: 11),
    //                   const DeadlineSelector(),
    //                 ],
    //               ),
    //               const SizedBox(height: 20),
    //
    //               // Submit Button
    //               ElevatedButton(
    //                 onPressed: isLoading ? null : _submitForm,
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: const Color(0xFF151864),
    //                   foregroundColor: Colors.white,
    //                   padding: const EdgeInsets.symmetric(vertical: 15),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(12),
    //                   ),
    //                   elevation: 5,
    //                 ),
    //                 child: Text(
    //                   isLoading ? "Submitting..." : "Submit Quiz",
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class ${widget.selectedClass}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Student List',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('parents')
            .where('level', isEqualTo: widget.selectedClass)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No students in ${widget.selectedClass}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final students = snapshot.data!.docs
              .map((doc) => Parent.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final student = students[index];
                      final avatarColor = _getRandomColor(student.studentName);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[200]!),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateStudentDetailsPage(
                                          student: student),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: 'avatar_${student.indexNumber}',
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor:
                                          avatarColor.withOpacity(0.2),
                                      child: Text(
                                        student.studentName[0].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: avatarColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.studentName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: ${student.indexNumber}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      student.level,
                                      style: const TextStyle(
                                        color: Color(0xFF151864),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: students.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddQuizForm(),
        backgroundColor: const Color(0xFF151864),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper method to create consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: const Color(0xFF151864)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF151864), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}

// Format deadline to a readable string
String _formatDeadline(DateTime deadline) {
  return '${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')}';
}
