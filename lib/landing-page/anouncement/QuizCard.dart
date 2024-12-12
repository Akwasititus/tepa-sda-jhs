import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;
  final String quizLink;
  final Future<void> Function(String) onLaunchQuiz;

  const QuizCard({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.quizLink,
    required this.onLaunchQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deadline: ${_formatDeadline(deadline)}',
                  style: TextStyle(
                    color:
                    _isDeadlineNear(deadline) ? Colors.red : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => onLaunchQuiz(quizLink),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isDeadlineNear(deadline)
                        ? Colors.white10
                        : const Color(0xFF151864),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isDeadlineNear(deadline)
                      ? const Text("Quiz Council",
                      style: TextStyle(color: Colors.white))
                      : const Text('Take Quiz',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // Format deadline to a readable string
  String _formatDeadline(DateTime deadline) {
    return '${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')}';
  }

  // Check if deadline is near (within 24 hours)
  bool _isDeadlineNear(DateTime deadline) {
    return deadline.isBefore(DateTime.now().add(const Duration(hours: 24)));
  }
}

