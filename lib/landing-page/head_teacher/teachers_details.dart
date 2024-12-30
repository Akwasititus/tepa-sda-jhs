import 'package:flutter/material.dart';
import '../../models/auth_teacher_model.dart';

class TeacherDetailsPage extends StatelessWidget {
  final Teacher teacher;

  const TeacherDetailsPage({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                teacher.teacherName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3494E6),
                      Color(0xFF151864),
                    ],
                  ),
                  image: DecorationImage(
                    image: const AssetImage('assets/abstract_background.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Color(0xFF151864),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        teacher.isHeadTeacher ? 'Head Teacher (YOU)' : 'Teacher',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoTile(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Email Address',
                  subtitle: teacher.teacherEmail,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.badge_outlined,
                  title: 'Staff ID',
                  subtitle: teacher.staffID,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.phone_outlined,
                  title: 'Contact Number',
                  subtitle: teacher.phoneContact,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.supervisor_account_outlined,
                  title: 'Head Teacher Status',
                  subtitle: teacher.isHeadTeacher ? 'Yes' : 'No',
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.man,
                  title: 'Gender',
                  subtitle: teacher.gender,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.flag_circle,
                  title: 'Ghana Card',
                  subtitle: teacher.ghanaCardNumber,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.local_police_outlined,
                  title: 'License Number',
                  subtitle: teacher.licenseNumber,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.single_bed,
                  title: 'Marital Status',
                  subtitle: teacher.maritalStatus,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.phone,
                  title: 'Phone Contact',
                  subtitle: teacher.phoneContact,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.school_sharp,
                  title: 'Previous School',
                  subtitle: teacher.previousSchoolAttended,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.high_quality,
                  title: 'Professional Qualification',
                  subtitle: teacher.professionalQualification,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF151864).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF151864),
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}