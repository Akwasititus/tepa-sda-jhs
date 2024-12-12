import 'package:flutter/material.dart';


class UserDetailScreen extends StatefulWidget {
  final String parentName;
  final String studentName;
  final String studentIndex;
  final String studentDob;
  final String studentPlaceOfBirth;
  final String studentGhanaCard;
  final String studentMotherLang;
  final String studentOccupation;
  final String studentParentEmail;
  final String studentMothersName;
  final String studentFathersName;
  final String studentNumberOfSiblings;
  final String studentDigitalAddress;
  final String studentPlaceOfStay;
  final String studentHomeTown;

  final double math;
  final double science;
  final double english;
  final double social;

  final String classRoomBehavior;
  final String classRoomParticipation;
  final String homeworkCompletion;

  final String averageGrade;
  final String classRank;
  final String attendance;




  final bool livesWithParent;
  final bool isFatherAlive;
  final bool isMotherAlive;

  const UserDetailScreen({
    super.key,
    required this.parentName,
    required this.studentName,
    required this.studentIndex,
    required this.studentDob,
    required this.studentPlaceOfBirth,
    required this.studentGhanaCard,
    required this.studentMotherLang,
    required this.studentOccupation,
    required this.studentParentEmail,
    required this.studentMothersName,
    required this.studentFathersName,
    required this.studentNumberOfSiblings,
    required this.livesWithParent,
    required this.isFatherAlive,
    required this.isMotherAlive,
    required this.studentDigitalAddress,
    required this.studentPlaceOfStay,
    required this.studentHomeTown,
    required this.classRoomBehavior,
    required this.classRoomParticipation,
    required this.homeworkCompletion,
    required this.math,
    required this.science,
    required this.english,
    required this.social,
    required this.averageGrade,
    required this.classRank,
    required this.attendance,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

    Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF151864),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildPerformanceMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

    Widget _buildSubjectPerformance(
      String subject, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


    Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF151864).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF151864), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchInfo(String label, bool value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: null,
            activeColor: const Color(0xFF151864),
            activeTrackColor: const Color(0xFF151864).withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String type, IconData icon) {
    return Column(
      children: [
        Container(

          height: 120,
          width: 120,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black, // Border color
              width: 2.0, // Border width
            ),
            color: Colors.white,
          ),

        ),
        const SizedBox(height: 12),
        Text(
          type,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const BackButton(color: Colors.white,),
        backgroundColor: const Color(0xFF151864),
        elevation: 10,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.school), text: 'Academics'),
            Tab(icon: Icon(Icons.person), text: 'Personal'),
            Tab(icon: Icon(Icons.family_restroom), text: 'Family'),
            Tab(icon: Icon(Icons.location_on), text: 'Location'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAcademicsTab(),
          _buildPersonalTab(),
          _buildFamilyTab(),
          _buildLocationTab(),
        ],
      ),
    );
  }

    Widget _buildPerformanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF818CF8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerformanceMetric('Average Grade', widget.averageGrade, Icons.grade),
              _buildPerformanceMetric('Class Rank', widget.classRank, Icons.leaderboard),
              _buildPerformanceMetric(
                  'Attendance', '${widget.attendance}%', Icons.calendar_today),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _buildPerformanceCard(),
          _buildSectionTitle('Subject Performance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildSubjectPerformance('Mathematics', widget.math, const Color(0xFF10B981)),
                _buildSubjectPerformance('Science', widget.science, const Color(0xFF6366F1)),
                _buildSubjectPerformance('English', widget.english, const Color(0xFFF59E0B)),
                _buildSubjectPerformance('Social Studies', widget.social, const Color(0xFF8B5CF6)),
              ],
            ),
          ),
          _buildSectionTitle('Behavior & Participation'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildBehaviorCard(
                  'Classroom Behavior',
                  widget.classRoomBehavior,
                  Icons.emoji_emotions,
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                _buildBehaviorCard(
                  'Participation',
                  widget.classRoomParticipation,
                  Icons.people,
                  const Color(0xFF6366F1),
                ),
                const SizedBox(height: 12),
                _buildBehaviorCard(
                  'Homework Completion',
                  '${widget.homeworkCompletion}% Completion On Time',
                  Icons.assignment_turned_in,
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionTitle('Profile pictures'),
          _buildProfileHeader(),
          ExpansionTile(
            title:  _buildSectionTitle('Basic Information'),
            children: [
              _buildInfoTile('Student Name', widget.studentName, Icons.person_outline),
              _buildInfoTile('Student ID', widget.studentIndex, Icons.badge),
              _buildInfoTile('Date of Birth', widget.studentDob, Icons.calendar_today),
              _buildInfoTile('Place of Birth', widget.studentPlaceOfBirth, Icons.location_city),
              _buildInfoTile('Ghana Card Number', widget.studentGhanaCard, Icons.credit_card),
            ],
          ),
          ExpansionTile(
            title:  _buildSectionTitle('Additional Information'),
            children: [
              _buildInfoTile('Mother Language', widget.studentMotherLang, Icons.language),
              _buildInfoTile('Occupation', widget.studentOccupation, Icons.work),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionTile(
            title:  _buildSectionTitle('Parent Information'),
            initiallyExpanded: true,
            children: [
              _buildInfoTile('Parent Name', widget.parentName, Icons.person),
              _buildInfoTile('Parent Email', widget.studentParentEmail, Icons.email),
            ],
          ),
          ExpansionTile(
            title:  _buildSectionTitle('Family Information'),
            children: [
              _buildInfoTile("Mother's Name", widget.studentMothersName, Icons.person),
              _buildInfoTile("Father's Name", widget.studentFathersName, Icons.person_outline),
              _buildInfoTile('Number of Siblings', widget.studentNumberOfSiblings, Icons.people),
              _buildSwitchInfo('Lives with Parents', widget.livesWithParent),
              _buildSwitchInfo('Father Deceased', widget.isFatherAlive),
              _buildSwitchInfo('Mother Deceased', widget.isMotherAlive),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionTile(
            title:  _buildSectionTitle('Current Location'),
            initiallyExpanded: true,
            children: [
              _buildInfoTile('Digital Address', widget.studentDigitalAddress, Icons.location_on),
              _buildInfoTile('Place of Stay', widget.studentPlaceOfStay, Icons.house),
            ],
          ),
          ExpansionTile(
            title:  _buildSectionTitle('Origin'),
            children: [
              _buildInfoTile('Hometown', widget.studentHomeTown, Icons.home),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProfileImage('Parent', Icons.person),
          _buildProfileImage('Student', Icons.person_outline),
        ],
      ),
    );
  }
}