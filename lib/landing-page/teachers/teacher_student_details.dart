import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/auth_model.dart';
import '../../widget/custom_button.dart';

class UpdateStudentDetailsPage extends StatefulWidget {
  final Parent student;

  const UpdateStudentDetailsPage({super.key, required this.student});

  @override
  _UpdateStudentDetailsPageState createState() =>
      _UpdateStudentDetailsPageState();
}

class _UpdateStudentDetailsPageState extends State<UpdateStudentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers grouped by category
  late final Map<String, TextEditingController> _academicControllers;
  late final Map<String, TextEditingController> _subjectControllers;
  late final Map<String, TextEditingController> _behaviorControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _academicControllers = {
      'attendance': TextEditingController(text: widget.student.attendance),
      'averageGrade': TextEditingController(text: widget.student.averageGrade),
      'classRank': TextEditingController(text: widget.student.classRank),
    };

    _subjectControllers = {
      'math': TextEditingController(text: widget.student.math.toString()),
      'science': TextEditingController(text: widget.student.science.toString()),
      'english': TextEditingController(text: widget.student.english.toString()),
      'social': TextEditingController(text: widget.student.social.toString()),
    };

    _behaviorControllers = {
      'classRoomBehavior':
          TextEditingController(text: widget.student.classRoomBehavior),
      'classRoomParticipation':
          TextEditingController(text: widget.student.classRoomParticipation),
      'homeWorkCompletion':
          TextEditingController(text: widget.student.homeworkCompletion),
    };
  }

  @override
  void dispose() {
    for (var controller in _academicControllers.values) {
      controller.dispose();
    }
    for (var controller in _subjectControllers.values) {
      controller.dispose();
    }
    for (var controller in _behaviorControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String textDescription,
    bool isNumeric = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumeric
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))]
                : null,
            validator: validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF151864), width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          Text(textDescription)
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF151864)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF151864),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _updateStudentDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('parents')
          .doc(widget.student.indexNumber)
          .update({
        'attendance': _academicControllers['attendance']!.text,
        'averageGrade': _academicControllers['averageGrade']!.text,
        'classRank': _academicControllers['classRank']!.text,
        'math': double.parse(_subjectControllers['math']!.text),
        'science': double.parse(_subjectControllers['science']!.text),
        'english': double.parse(_subjectControllers['english']!.text),
        'social': double.parse(_subjectControllers['social']!.text),
        'classRoomBehavior': _behaviorControllers['classRoomBehavior']!.text,
        'classRoomParticipation':
            _behaviorControllers['classRoomParticipation']!.text,
        'homeWorkCompletion': _behaviorControllers['homeWorkCompletion']!.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student details updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              widget.student.studentName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Class ${widget.student.level}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSection(
              title: 'Academic Performance',
              icon: Icons.school,
              children: [
                _buildInputField(
                  label: 'Attendance Rate (%)',
                  controller: _academicControllers['attendance']!,
                  isNumeric: true,
                  hint: 'Enter attendance percentage',
                  textDescription: 'Example: 80,90,20',
                ),
                _buildInputField(
                  label: 'Average Grade',
                  controller: _academicControllers['averageGrade']!,
                  hint: 'Enter average grade',
                  textDescription: 'Example: A+, B+, F',
                ),
                _buildInputField(
                  label: 'Class Rank',
                  controller: _academicControllers['classRank']!,
                  hint: 'Enter class rank',
                  textDescription: 'Example: 1st, 2nd, 3rd',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Subject Performance',
              icon: Icons.book,
              children: [
                _buildInputField(
                  label: 'Mathematics',
                  controller: _subjectControllers['math']!,
                  isNumeric: true,
                  hint: 'Enter math score',
                  textDescription: 'Example: 1.00, 0.43, 0.90',
                ),
                _buildInputField(
                  label: 'Science',
                  controller: _subjectControllers['science']!,
                  isNumeric: true,
                  hint: 'Enter science score',
                  textDescription: 'Example: 1.00, 0.43, 0.90',
                ),
                _buildInputField(
                  label: 'English',
                  controller: _subjectControllers['english']!,
                  isNumeric: true,
                  hint: 'Enter English score',
                  textDescription: 'Example: 1.00, 0.43, 0.90',
                ),
                _buildInputField(
                  label: 'Social Studies',
                  controller: _subjectControllers['social']!,
                  isNumeric: true,
                  hint: 'Enter social studies score',
                  textDescription: 'Example: 1.00, 0.43, 0.90',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Behavior & Participation',
              icon: Icons.psychology,
              children: [
                _buildInputField(
                  label: 'Classroom Behavior',
                  controller: _behaviorControllers['classRoomBehavior']!,
                  hint: 'Enter behavior assessment',
                  textDescription: 'Example: Excelent',
                ),
                _buildInputField(
                  label: 'Class Participation',
                  controller: _behaviorControllers['classRoomParticipation']!,
                  hint: 'Enter participation level',
                  textDescription: '',
                ),
                _buildInputField(
                  label: 'Homework Completion',
                  controller: _behaviorControllers['homeWorkCompletion']!,
                  hint: 'Enter homework completion rate',
                  textDescription: '',
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              color: const Color(0xFF151864),
              text: _isLoading ? 'Updating...' : 'Update Details',
              onPressed: _updateStudentDetails,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
