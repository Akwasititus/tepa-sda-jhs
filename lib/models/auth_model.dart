class Parent {
  final String parentEmail;
  final String parentName;
  final String studentName;
  final String indexNumber;
  final String level;
  final String dob;
  final String birthplace;
  final String motherName;
  final String fatherName;
  final String siblings;
  final String ghanaCardNumber;
  final String digitalAddress;
  final String hometown;
  final String motherLanguage;
  final String occupation;
  final String placeOfStay;
  final bool liveWithParents;
  final bool fatherDeceased;
  final bool motherDeceased;
  final String parentImage;
  final String childImage;

  final String averageGrade;
  final String classRank;
  final String attendance;

  final double math;
  final double science;
  final double english;
  final double social;

  final String classRoomBehavior;
  final String classRoomParticipation;
  final String homeworkCompletion;

  Parent({
    required this.math,
    required this.science,
    required this.english,
    required this.social,
    required this.averageGrade,
    required this.classRank,
    required this.attendance,
    required this.parentEmail,
    required this.classRoomBehavior,
    required this.classRoomParticipation,
    required this.homeworkCompletion,
    required this.parentName,
    required this.studentName,
    required this.indexNumber,
    required this.level,
    required this.dob,
    required this.birthplace,
    required this.motherName,
    required this.fatherName,
    required this.siblings,
    required this.ghanaCardNumber,
    required this.digitalAddress,
    required this.hometown,
    required this.motherLanguage,
    required this.occupation,
    required this.placeOfStay,
    required this.liveWithParents,
    required this.fatherDeceased,
    required this.motherDeceased,
    required this.parentImage,
    required this.childImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'science': science,
      'math': math,
      'english': english,
      'social': social,
      'averageGrade': averageGrade,
      'classRank': classRank,
      'attendance': attendance,
      'classRoomBehavior': classRoomBehavior,
      'classRoomParticipation': classRoomParticipation,
      'homeWorkCompletion': homeworkCompletion,
      'parentEmail': parentEmail,
      'parentName': parentName,
      'studentName': studentName,
      'indexNumber': indexNumber,
      'level': level,
      'dob': dob,
      'birthplace': birthplace,
      'motherName': motherName,
      'fatherName': fatherName,
      'siblings': siblings,
      'ghanaCardNumber': ghanaCardNumber,
      'digitalAddress': digitalAddress,
      'hometown': hometown,
      'motherLanguage': motherLanguage,
      'occupation': occupation,
      'placeOfStay': placeOfStay,
      'liveWithParents': liveWithParents,
      'fatherDeceased': fatherDeceased,
      'motherDeceased': motherDeceased,
      'parentImage': parentImage,
      'childImage': childImage,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
    return Parent(
      classRoomBehavior: map['classRoomBehavior'],
      classRoomParticipation: map['classRoomParticipation'],
      homeworkCompletion: map['homeWorkCompletion'],
      parentEmail: map['parentEmail'] ?? '',
      parentName: map['parentName'] ?? '',
      studentName: map['studentName'] ?? '',
      indexNumber: map['indexNumber'] ?? '',
      level: map['level'] ?? '',
      dob: map['dob'],
      birthplace: map['birthplace'],
      motherName: map['motherName'],
      fatherName: map['fatherName'],
      siblings: map['siblings'],
      ghanaCardNumber: map['ghanaCardNumber'],
      digitalAddress: map['digitalAddress'],
      hometown: map['hometown'],
      motherLanguage: map['motherLanguage'],
      occupation: map['occupation'],
      placeOfStay: map['placeOfStay'],
      liveWithParents: map['liveWithParents'],
      fatherDeceased: map['fatherDeceased'],
      motherDeceased: map['motherDeceased'],
      parentImage: map['parentImage'],
      childImage: map['childImage'],
      math: map['math'],
      science: map['science'],
      english: map['english'],
      social: map['social'],
      averageGrade: map['averageGrade'],
      classRank: map['classRank'],
      attendance: map['attendance'],
    );
  }
}

