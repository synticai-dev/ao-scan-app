import 'package:cloud_firestore/cloud_firestore.dart';
import 'session_model.dart';

class ClientRecordModel {
  final String clientCode;
  final String userId;
  final DateTime createdAt;
  final List<SessionModel> sessions;

  ClientRecordModel({
    required this.clientCode,
    required this.userId,
    required this.createdAt,
    required this.sessions,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientCode': clientCode,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'sessions': sessions.map((s) => s.toMap()).toList(),
    };
  }

  factory ClientRecordModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedCreatedAt = DateTime.now();
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        parsedCreatedAt = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is String) {
        parsedCreatedAt = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
      }
    }

    var sessionsList = <SessionModel>[];
    if (map['sessions'] != null && map['sessions'] is List) {
      sessionsList = (map['sessions'] as List)
          .map((s) => SessionModel.fromMap(Map<String, dynamic>.from(s)))
          .toList();
    }

    return ClientRecordModel(
      clientCode: map['clientCode'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: parsedCreatedAt,
      sessions: sessionsList,
    );
  }
}
