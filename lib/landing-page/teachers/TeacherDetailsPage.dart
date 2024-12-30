import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherProfilePage extends StatefulWidget {
  final String staffID;

  const TeacherProfilePage({super.key, required this.staffID});

  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  late Future<DocumentSnapshot> _teacherFuture;

  @override
  void initState() {
    super.initState();
    _teacherFuture = FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.staffID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _teacherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Teacher not found'),
                ],
              ),
            );
          }

          Map<String, dynamic> teacherData = snapshot.data!.data() as Map<String, dynamic>;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFF151864),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Hero(
                        tag: 'teacher_avatar_${teacherData['staffID']}',
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Text(
                            teacherData['teacherName'][0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 48,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        teacherData['teacherName'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Your ID: ${teacherData['staffID']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          'Contact Information',
                          [
                            _buildInfoTile(Icons.email, 'Email', teacherData['teacherEmail']),
                            _buildInfoTile(Icons.phone, 'Phone', teacherData['phoneContact']),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          'Professional Details',
                          [
                            _buildInfoTile(Icons.school, 'Level', teacherData['level']),
                            _buildInfoTile(Icons.workspace_premium, 'Qualification',
                                teacherData['professionalQualification']),
                            _buildInfoTile(Icons.badge, 'License Number', teacherData['licenseNumber']),
                            _buildInfoTile(Icons.credit_card, 'Ghana Card', teacherData['ghanaCardNumber']),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          'Personal Information',
                          [
                            _buildInfoTile(Icons.person, 'Gender', teacherData['gender']),
                            _buildInfoTile(Icons.favorite, 'Marital Status', teacherData['maritalStatus']),
                            _buildInfoTile(Icons.history_edu, 'Previous School',
                                teacherData['previousSchoolAttended']),
                            _buildInfoTile(
                              Icons.admin_panel_settings,
                              'Head Teacher',
                              teacherData['isHeadTeacher'] ? 'Yes' : 'No',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
                icon,
                color: const Color(0xFF151864)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}