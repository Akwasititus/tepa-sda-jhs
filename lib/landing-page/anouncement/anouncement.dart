import 'package:flutter/material.dart';

import 'GenAnnouncement.dart';
import 'Quiz.dart';

class Announcement extends StatefulWidget {
  final String indexNumber;
  const Announcement({super.key, required this.indexNumber});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEEEEE),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: TabBar(
                padding: const EdgeInsets.only(bottom: 10),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius. circular(40),
                ),
                splashBorderRadius: BorderRadius. circular(40),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF151864)),
                tabs: const [
                  Text("Gen. Announcement"),
                  Text("Quiz"),
                ])
        ),
      ),
      body: TabBarView(children: [
        const GenAnnouncement(),
        QuizPage(indexNumber: widget.indexNumber),
      ]),
    ));
  }
}
