import 'package:flutter/material.dart';

import '../parents/parents.dart';
import '../teachers/teachers.dart';
import 'all_students.dart';
import 'head_teacher_landing_page.dart';

class AllClasses extends StatelessWidget {
  const AllClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,                                          /// TITUS WHAT YOU CAN DO IS TO CREATE A NEW GET STUDENT FOR HEAD MASTER
                  MaterialPageRoute(builder: (context) =>  const AllStudent(level: 'JW3',),),
                );
              },
              child: const Text('JW3')
          )
        ],
      ),
    );
  }
}
