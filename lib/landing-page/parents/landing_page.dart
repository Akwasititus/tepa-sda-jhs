import 'package:flutter/material.dart';
import 'package:sda/landing-page/parents/parents.dart';
import 'package:sda/landing-page/parents/profile_page.dart';


import '../anouncement/anouncement.dart';

class LandingPage extends StatefulWidget {
  final String indexNumber;

  const LandingPage({super.key, required this.indexNumber});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentIndex = 0;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      ParentHomePage(indexNumber: widget.indexNumber),
      Announcement(indexNumber: widget.indexNumber),
      ProfileUpdateScreen(indexNumber: widget.indexNumber),
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
              label: 'Parents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: 'Announcement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
