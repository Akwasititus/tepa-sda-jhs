// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'date.dart';
//
// class CreateQuizPage extends StatefulWidget {
//   const CreateQuizPage({Key? key}) : super(key: key);
//
//   @override
//   _CreateQuizPageState createState() => _CreateQuizPageState();
// }
//
// class _CreateQuizPageState extends State<CreateQuizPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   String title = '';
//   String description = '';
//   String quizLink = '';
//   String level = '';
//   DateTime? deadline;
//
//   void _onDeadlineSelected(DateTime selectedDeadline) {
//     setState(() {
//       deadline = selectedDeadline;
//     });
//   }
//
//   Future<void> _createQuiz() async {
//     // if (_formKey.currentState!.validate() && deadline != null) {
//       try {
//         await FirebaseFirestore.instance.collection('quizzes').add({
//           'title': title,
//           'description': description,
//           'quizLink': quizLink,
//           'level': level,
//           'deadline': Timestamp.fromDate(deadline!),
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Quiz created successfully')),
//         );
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create quiz: $e')),
//         );
//       }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Quiz')),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16.0),
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Title'),
//               validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
//               onSaved: (value) => title = value!,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Description'),
//               validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
//               onSaved: (value) => description = value!,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Quiz Link'),
//               validator: (value) => value!.isEmpty ? 'Please enter a quiz link' : null,
//               onSaved: (value) => quizLink = value!,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Level'),
//               validator: (value) => value!.isEmpty ? 'Please enter a level' : null,
//               onSaved: (value) => level = value!,
//             ),
//             const SizedBox(height: 20),
//             // DeadlineSelector(onDateTimeSelected: _onDeadlineSelected),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();
//                   _createQuiz();
//                 }
//               },
//               child: const Text('Create Quiz'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }