import 'package:flutter/material.dart';
import 'package:sda/landing-page/head_teacher/all_classes.dart';
import 'package:sda/landing-page/teachers/teachers.dart';

import '../../models/auth_teacher_model.dart';

import 'head_teacher.dart';

class HeadTeachersLandingPage extends StatefulWidget {
  // final String selectedClass;
  // final String staffID;

  const HeadTeachersLandingPage(
      {super.key});

  @override
  State<HeadTeachersLandingPage> createState() => _HeadTeachersLandingPageState();
}

class _HeadTeachersLandingPageState extends State<HeadTeachersLandingPage> {
  int currentIndex = 0;

  late List<Widget> screens;
  Teacher? teacher;

  @override
  void initState() {
    super.initState();

    screens = [
      const HeadTeacherDashboard(),
      const AllClasses()
      // StudentsListPage(selectedClass: widget.selectedClass),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 5),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color(0xFF151864),
          iconSize: 20,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Teachers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Parents',
            ),
          ],
        ),
      ),
    );
  }
}
