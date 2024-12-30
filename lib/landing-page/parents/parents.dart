import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sda/landing-page/parents/student_details.dart';
import '../../models/auth_model.dart';


class ParentHomePage extends StatefulWidget {
  final String indexNumber;

  const ParentHomePage({super.key, required this.indexNumber});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  late Parent? currentUser;
  final List<Parent> allParents = [];
  final TextEditingController _searchController = TextEditingController();
  List<Parent> filteredParents = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String greeting = '';
  String currentPeriod = '';
  String timeRemaining = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    _updateGreeting();
    _updateSchoolPeriod();
    // Update time every minute
    Stream.periodic(const Duration(minutes: 1)).listen((_) {
      _updateSchoolPeriod();
      _updateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 15) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
  }

  void _updateSchoolPeriod() {
    var now = DateTime.now();
    var day = now.weekday; // Get the current day of the week
    var time = TimeOfDay.fromDateTime(now);
    var minutes = time.hour * 60 + time.minute;

    if (day == DateTime.saturday || day == DateTime.sunday) {
      // Weekend case
      currentPeriod = 'Happy Weekends';
      timeRemaining = ''; // No time remaining on weekends
    } else {
      // Define school periods based on the new table
      if (minutes >= 480 && minutes < 570) {
        // 8:00 - 9:30
        currentPeriod = '1st and 2nd period';
      } else if (minutes >= 570 && minutes < 615) {
        // 9:30 - 10:15
        currentPeriod = 'First Break';
      } else if (minutes >= 615 && minutes < 705) {
        // 10:15 - 11:45
        currentPeriod = '3rd and 4th period';
      } else if (minutes >= 705 && minutes < 795) {
        // 11:45 - 1:15
        currentPeriod = '5th and 6th period';
      } else if (minutes >= 795 && minutes < 810) {
        // 1:15 - 1:30
        currentPeriod = '2nd lunch break';
      } else if (minutes >= 810 && minutes < 900) {
        // 1:30 - 3:00
        currentPeriod = '7th and 8th period';
      } else {
        // 3:00 and onwards
        currentPeriod = 'School Closed';
      }

      _updateTimeRemaining(); // Update time remaining for active periods
    }

    setState(() {});
  }

  Widget _getPeriodIcon() {
    switch (currentPeriod) {
      case 'Happy Weekends':
        return const Icon(Icons.weekend, size: 50, color: Colors.white);
      case '1st and 2nd period':
      case '3rd and 4th period':
      case '5th and 6th period':
      case '7th and 8th period':
        return const Icon(Icons.school, size: 50, color: Colors.white);
      case 'First Break':
        return const Icon(Icons.free_breakfast, size: 50, color: Colors.white);
      case '2nd lunch break':
        return const Icon(Icons.lunch_dining, size: 50, color: Colors.white);
      case 'School Closed':
        return const Icon(Icons.lock, size: 50, color: Colors.white);
      default:
        return const Icon(Icons.schedule, size: 50, color: Colors.white);
    }
  }

  void _updateTimeRemaining() {
    var now = DateTime.now();
    var time = TimeOfDay.fromDateTime(now);
    var currentMinutes = time.hour * 60 + time.minute;
    int remainingMinutes;

    switch (currentPeriod) {
      case '1st and 2nd period':
        remainingMinutes = 570 - currentMinutes;
        timeRemaining = '$remainingMinutes minutes remaining for First Break';
        break;
      case 'First Break':
        remainingMinutes = 615 - currentMinutes;
        timeRemaining = '$remainingMinutes minutes remaining for 3rd and 4th period';
        break;
      case '3rd and 4th period':
        remainingMinutes = 705 - currentMinutes;
        timeRemaining = '$remainingMinutes minutes remaining for 5th and 6th period';
        break;
      case '5th and 6th period':
        remainingMinutes = 795 - currentMinutes;
        timeRemaining = '$remainingMinutes minutes remaining for 2nd lunch break';
        break;
      case '2nd lunch break':
        remainingMinutes = 810 - currentMinutes;
        timeRemaining = '$remainingMinutes minutes remaining for 7th and 8th period';
        break;
      case '7th and 8th period':
        remainingMinutes = 900 - currentMinutes;
        timeRemaining = '$remainingMinutes minutes remaining for School Closed';
        break;
      default:
        timeRemaining = 'School Closed';
    }

    setState(() {});
  }


  Future<void> fetchCurrentUser() async {

    final userDoc = await FirebaseFirestore.instance
        .collection('parents')
        .doc(widget.indexNumber)
        .get();

    if (userDoc.exists) {
      setState(() {
        currentUser = Parent.fromMap(userDoc.data()!);
      });
      fetchAllParents(currentUser!.level);
    }
  }

  Future<void> fetchAllParents(String level) async {
    await Future.delayed(const Duration(seconds: 2 ));
    final querySnapshot = await FirebaseFirestore.instance
        .collection('parents')
        .where('level', isEqualTo: level)
        .get();

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

  @override
  Widget build(BuildContext context) {
    // If currentUser is null, show loading
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => fetchCurrentUser(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF151864),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF1E2B8C),
                        Color(0xFF151864),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...[
                              Text(
                                greeting,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentUser!.parentName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Current Period Card
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              currentPeriod,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          timeRemaining,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _getPeriodIcon()
                                  ],
                                ),
                              ),
                            ],
                            ],
                          ),
                        ),
                      ),
                    ],
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
                              Text(
                                'Class: ${currentUser?.level ?? "please wait..."}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
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
                    // const SizedBox(height: 10),
                    // Parents List
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredParents.length,
                      itemBuilder: (context, index) {
                        final parent = filteredParents[index];
                        final isCurrentUser = parent.indexNumber == currentUser?.indexNumber;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: isCurrentUser ? 4 : 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: isCurrentUser
                                ? () {
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
                                      studentDigitalAddress: parent.digitalAddress,
                                      studentPlaceOfStay: parent.placeOfStay,
                                      studentHomeTown: parent.hometown,
                                      classRoomBehavior:parent.classRoomBehavior,
                                      classRoomParticipation: parent.classRoomParticipation,
                                      homeworkCompletion: parent.homeworkCompletion,
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
                              }
                              : null,
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: !isCurrentUser ? Text(
                                        'Class ${parent.level}',
                                        style: const TextStyle(
                                          color: Color(0xFF151864),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                          : const Text("You",style: TextStyle(
                                        color: Color(0xFF151864),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),)
                                    ),
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
