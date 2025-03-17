// import 'package:flutter/material.dart';
//
// import '../parents/parents.dart';
// import '../teachers/teachers.dart';
// import 'all_students.dart';
// import 'head_teacher_landing_page.dart';
//
// class AllClasses extends StatelessWidget {
//   const AllClasses({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           ElevatedButton(
//               onPressed: (){
//                 Navigator.push(
//                   context,                                          /// TITUS WHAT YOU CAN DO IS TO CREATE A NEW GET STUDENT FOR HEAD MASTER
//                   MaterialPageRoute(builder: (context) =>  const AllStudent(level: 'JW3',),),
//                 );
//               },
//               child: const Text('JW3')
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sda/landing-page/parents/student_details.dart';
import '../../models/auth_model.dart';

class AllStudent extends StatefulWidget {
  const AllStudent({super.key});

  @override
  State<AllStudent> createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  final List<Parent> allParents = [];
  final TextEditingController _searchController = TextEditingController();
  List<Parent> filteredParents = [];
  String? selectedLevel;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchAllParents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAllParents() async {
    await Future.delayed(const Duration(seconds: 2));
    final querySnapshot =
        await FirebaseFirestore.instance.collection('parents').get();

    setState(() {
      allParents.clear();
      allParents
          .addAll(querySnapshot.docs.map((doc) => Parent.fromMap(doc.data())));
      filteredParents = List.from(allParents);
    });
  }

  void _filterParents(String query) {
    setState(() {
      filteredParents = allParents
          .where((parent) =>
              parent.parentName.toLowerCase().contains(query.toLowerCase()) ||
              parent.studentName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterByLevel(String? level) {
    setState(() {
      selectedLevel = level;
      if (level == null) {
        filteredParents = List.from(allParents);
      } else {
        filteredParents =
            allParents.where((parent) => parent.level == level).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchAllParents,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              title: const Text("Parents", style: TextStyle(color: Colors.white),),
              actions: [
                IconButton(
                    onPressed: fetchAllParents, icon: const Icon(Icons.refresh, color:  Colors.white, size: 35,))
              ],
              automaticallyImplyLeading: false,
              expandedHeight: 50.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF151864),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    color:  Color(0xFF151864),

                  ),
                  child: Stack(
                    children: [],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterParents,
                        decoration: const InputDecoration(
                          hintText: 'Search parents or students...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Level Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedLevel,
                      decoration: InputDecoration(
                        labelText: 'Select Level',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        'JW1',
                        'JW2',
                        'JW3',
                        'JB1',
                        'JB2',
                        'JB3',
                        'EW1',
                        'EW2',
                        'EW3'
                      ].map((String level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: _filterByLevel,
                    ),
                    const SizedBox(height: 20),
                    // Class Stats
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF151864).withOpacity(0.8),
                            const Color(0xFF1E2B8C).withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '${filteredParents.length} Students',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.people_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Parents List
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredParents.length,
                      itemBuilder: (context, index) {
                        final parent = filteredParents[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDetailScreen(
                                      parentName: parent.parentName,
                                      studentName: parent.studentName,
                                      studentIndex: parent.indexNumber,
                                      studentDob: parent.dob,
                                      studentPlaceOfBirth: parent.birthplace,
                                      studentGhanaCard: parent.ghanaCardNumber,
                                      studentMotherLang: parent.motherLanguage,
                                      studentOccupation: parent.occupation,
                                      studentParentEmail: parent.parentEmail,
                                      studentMothersName: parent.motherName,
                                      studentFathersName: parent.fatherName,
                                      studentNumberOfSiblings: parent.siblings,
                                      livesWithParent: parent.liveWithParents,
                                      isFatherAlive: parent.fatherDeceased,
                                      isMotherAlive: parent.motherDeceased,
                                      studentDigitalAddress:
                                          parent.digitalAddress,
                                      studentPlaceOfStay: parent.placeOfStay,
                                      studentHomeTown: parent.hometown,
                                      classRoomBehavior:
                                          parent.classRoomBehavior,
                                      classRoomParticipation:
                                          parent.classRoomParticipation,
                                      homeworkCompletion:
                                          parent.homeworkCompletion,
                                      math: parent.math,
                                      science: parent.science,
                                      english: parent.english,
                                      social: parent.english,
                                      averageGrade: parent.averageGrade,
                                      classRank: parent.classRank,
                                      attendance: parent.attendance,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF151864)
                                                .withOpacity(0.1),
                                            const Color(0xFF1E2B8C)
                                                .withOpacity(0.2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          parent.parentName[0],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            parent.parentName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.school_outlined,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                parent.studentName,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF151864)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child:  Text(
                                          parent.level,
                                          style: TextStyle(
                                            color: Color(0xFF151864),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
