import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/auth_model.dart';
import 'QuizCard.dart';

class QuizPage extends StatefulWidget {
  final String indexNumber;
  const QuizPage({super.key, required this.indexNumber});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Parent? currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }
  // Function to launch URL (Google Form)
  Future<void> _launchQuizForm(String quizLink) async {
    final Uri url = Uri.parse(quizLink);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(widget.indexNumber)
          .get();

      if (userDoc.exists) {
        setState(() {
          currentUser = Parent.fromMap(userDoc.data()!);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally handle the error, e.g., show a snackbar or print
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // First, check if the user is still loading
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If user is loaded but no level is set, show an error
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Unable to load user data',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .where('level', isEqualTo: currentUser!.level)
        .orderBy('deadline', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No quizzes available for this class',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var quiz = snapshot.data!.docs[index];
              return QuizCard(
                title: quiz['title'],
                description: quiz['description'],
                deadline: (quiz['deadline'] as Timestamp).toDate(),
                quizLink: quiz['quizLink'],
                onLaunchQuiz: _launchQuizForm,
              );
            },
          );
        },
      ),
    );
  }
}