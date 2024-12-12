import 'package:flutter/material.dart';

class DeadlineSelector extends StatefulWidget {
  const DeadlineSelector({super.key});

  @override
  _DeadlineSelectorState createState() => _DeadlineSelectorState();
}

class _DeadlineSelectorState extends State<DeadlineSelector> {
  DateTime? _deadline;

  // Function to format the selected deadline
  String _formatDeadline(DateTime deadline) {
    return '${deadline.day}/${deadline.month}/${deadline.year}';
  }

  // Function to select a deadline
  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Update _deadline and rebuild the UI
      setState(() {
        _deadline = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDeadline(context),
        child: Text(
          _deadline != null
              ? 'Deadline: ${_formatDeadline(_deadline!)}'
              : 'Click to Select a Deadline for your quiz',
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
