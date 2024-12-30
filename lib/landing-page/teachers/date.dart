// import 'package:flutter/material.dart';
//
// class DeadlineSelector extends StatefulWidget {
//   const DeadlineSelector({super.key});
//
//   @override
//   _DeadlineSelectorState createState() => _DeadlineSelectorState();
// }
//
// class _DeadlineSelectorState extends State<DeadlineSelector> {
//   DateTime? deadline;
//
//   // Function to format the selected deadline
//   String _formatDeadline(DateTime deadline) {
//     return '${deadline.day}/${deadline.month}/${deadline.year}/${deadline.minute}';
//
//   }
//
//   // Function to select a deadline
//   Future<void> _selectDeadline(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: deadline ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       // Update _deadline and rebuild the UI
//       setState(() {
//         deadline = pickedDate;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => _selectDeadline(context),
//         child: Text(
//           deadline != null
//               ? 'Deadline: ${_formatDeadline(deadline!)}'
//               : 'Click to Select a Deadline for your quiz',
//           style: const TextStyle(
//             color: Colors.blue,
//             decoration: TextDecoration.underline,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class DeadlineSelector extends StatefulWidget {
  final void Function(DateTime) onDeadlineSelected;
  final DateTime? initialDeadline;

  const DeadlineSelector({
    super.key,
    required this.onDeadlineSelected,
    this.initialDeadline,
  });

  @override
  _DeadlineSelectorState createState() => _DeadlineSelectorState();
}

class _DeadlineSelectorState extends State<DeadlineSelector> {
  DateTime? deadline;

  @override
  void initState() {
    super.initState();
    deadline = widget.initialDeadline;
  }

  // Function to format the selected deadline
  String _formatDeadline(DateTime deadline) {
    return '${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')}';
  }

  // Function to select a deadline
  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now(),  // Prevent selecting past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // After selecting date, show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          deadline = combinedDateTime;
        });

        // Notify parent widget of the selected deadline
        widget.onDeadlineSelected(combinedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quiz Deadline',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectDeadline(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deadline != null
                        ? _formatDeadline(deadline!)
                        : 'Select deadline',
                    style: TextStyle(
                      color: deadline != null ? Colors.black : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}