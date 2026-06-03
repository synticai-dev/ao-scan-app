import 'package:cloud_firestore/cloud_firestore.dart';

class DemoRequestModel {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String country;
  final String phoneCountryCode;
  final String phoneNumber;
  final String sex;
  final String weight;
  final String weightUnit;
  final String height;
  final String heightUnit;
  final String dateOfBirth;
  final String occupation;
  final String useType;
  final String? message;
  final String? photoUrl;
  final String? audioUrl;
  final DateTime submissionDate;
  final String status; // Pending, Approved, Rejected
  final String? adminNote;

  DemoRequestModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.sex,
    required this.weight,
    required this.weightUnit,
    required this.height,
    required this.heightUnit,
    required this.dateOfBirth,
    required this.occupation,
    required this.useType,
    this.message,
    this.photoUrl,
    this.audioUrl,
    required this.submissionDate,
    required this.status,
    this.adminNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'country': country,
      'phoneCountryCode': phoneCountryCode,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'weight': weight,
      'weightUnit': weightUnit,
      'height': height,
      'heightUnit': heightUnit,
      'dateOfBirth': dateOfBirth,
      'occupation': occupation,
      'useType': useType,
      'message': message,
      'photoUrl': photoUrl,
      'audioUrl': audioUrl,
      'submissionDate': submissionDate,
      'status': status,
      'adminNote': adminNote,
    };
  }

  factory DemoRequestModel.fromMap(Map<String, dynamic> map) {
    return DemoRequestModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      country: map['country'] ?? '',
      phoneCountryCode: map['phoneCountryCode'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      sex: map['sex'] ?? '',
      weight: map['weight'] ?? '',
      weightUnit: map['weightUnit'] ?? '',
      height: map['height'] ?? '',
      heightUnit: map['heightUnit'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      occupation: map['occupation'] ?? '',
      useType: map['useType'] ?? '',
      message: map['message'],
      photoUrl: map['photoUrl'],
      audioUrl: map['audioUrl'],
      submissionDate: (map['submissionDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'Pending',
      adminNote: map['adminNote'],
    );
  }
}
