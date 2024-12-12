class Teacher {
  final String teacherEmail;
  final String teacherName;
  final String staffID;
  final String level;
  final bool isHeadTeacher;
  final String professionalQualification;
  final String ghanaCardNumber;
  final String licenseNumber;
  final String phoneContact;
  final String previousSchoolAttended;
  final String gender;
  final String maritalStatus;

  Teacher(
      {required this.professionalQualification,
        required this.ghanaCardNumber,
        required this.licenseNumber,
        required this.phoneContact,
        required this.previousSchoolAttended,
        required this.gender,
        required this.maritalStatus,
        required this.teacherEmail,
        required this.teacherName,
        required this.staffID,
        required this.level,
        required this.isHeadTeacher});

  Map<String, dynamic> toMap() {
    return {
      'teacherEmail': teacherEmail,
      'teacherName': teacherName,
      'staffID': staffID,
      'level': level,
      'isHeadTeacher': isHeadTeacher,
      'professionalQualification': professionalQualification,
      'ghanaCardNumber': ghanaCardNumber,
      'licenseNumber':licenseNumber,
      'phoneContact':phoneContact,
      'previousSchoolAttended':previousSchoolAttended,
      'gender':gender,
      'maritalStatus':maritalStatus
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      teacherEmail: map['teacherEmail'],
      teacherName: map['teacherName'],
      staffID: map['staffID'],
      level: map['level'] ?? '',
      isHeadTeacher: map['isHeadTeacher'] ?? false,
      professionalQualification: map['professionalQualification'],
      ghanaCardNumber: map['ghanaCardNumber'],
      licenseNumber: map['licenseNumber'],
      phoneContact: map['phoneContact'],
      previousSchoolAttended: map['previousSchoolAttended'],
      gender: map['gender'],
      maritalStatus: map['maritalStatus'],
    );
  }
}
