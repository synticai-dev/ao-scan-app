import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final int sessionSequence;
  final List<String> modulesUsed;
  final List<String> wellnessConcerns;
  final List<String> energeticPatterns;
  final DateTime timestamp;

  SessionModel({
    required this.sessionSequence,
    required this.modulesUsed,
    required this.wellnessConcerns,
    required this.energeticPatterns,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionSequence': sessionSequence,
      'modulesUsed': modulesUsed,
      'wellnessConcerns': wellnessConcerns,
      'energeticPatterns': energeticPatterns,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedTimestamp = DateTime.now();
    if (map['timestamp'] != null) {
      if (map['timestamp'] is Timestamp) {
        parsedTimestamp = (map['timestamp'] as Timestamp).toDate();
      } else if (map['timestamp'] is String) {
        parsedTimestamp = DateTime.tryParse(map['timestamp']) ?? DateTime.now();
      }
    }

    return SessionModel(
      sessionSequence: map['sessionSequence'] ?? 1,
      modulesUsed: List<String>.from(map['modulesUsed'] ?? []),
      wellnessConcerns: List<String>.from(map['wellnessConcerns'] ?? []),
      energeticPatterns: List<String>.from(map['energeticPatterns'] ?? []),
      timestamp: parsedTimestamp,
    );
  }
}
