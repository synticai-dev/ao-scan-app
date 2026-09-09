import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? dob;
  final String? occupation;
  final String? country;
  final String? phoneNumber;
  final String? sex;
  final String? originPlatform;
  final Map<String, dynamic>? lastActivePlatforms;
  final bool? phoneVerified;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.firstName,
    this.lastName,
    this.dob,
    this.occupation,
    this.country,
    this.phoneNumber,
    this.sex,
    this.originPlatform,
    this.lastActivePlatforms,
    this.phoneVerified,
    this.createdAt,
  });

  String get fullName => "${firstName ?? ''} ${lastName ?? ''}".trim();
  String get name => firstName ?? 'User';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'occupation': occupation,
      'country': country,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'originPlatform': originPlatform,
      'lastActivePlatforms': lastActivePlatforms,
      'phoneVerified': phoneVerified ?? false,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'],
      lastName: map['lastName'],
      dob: map['dob'],
      occupation: map['occupation'],
      country: map['country'],
      phoneNumber: map['phoneNumber'],
      sex: map['sex'],
      originPlatform: map['originPlatform'],
      lastActivePlatforms: map['lastActivePlatforms'] != null ? Map<String, dynamic>.from(map['lastActivePlatforms']) : null,
      phoneVerified: map['phoneVerified'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
