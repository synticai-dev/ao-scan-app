import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/client_record_model.dart';
import '../models/session_model.dart';
import '../utils/records_constants.dart';
import 'auth_controller.dart';

class RecordsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  RxList<ClientRecordModel> clientRecords = <ClientRecordModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClientRecords();
  }

  /// Generates an 8-character random code with 'AO-' prefix (e.g. AO-7K4P9M2Q)
  String generateClientCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    final codeBuffer = StringBuffer('AO-');
    for (int i = 0; i < 8; i++) {
      codeBuffer.write(chars[random.nextInt(chars.length)]);
    }
    return codeBuffer.toString();
  }

  /// Streams client records for the currently authenticated user
  void fetchClientRecords() {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) return;

    isLoading.value = true;
    _firestore
        .collection('users')
        .doc(uid)
        .collection('client_records')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            clientRecords.value = snapshot.docs
                .map((doc) => ClientRecordModel.fromMap(doc.data()))
                .toList();
            isLoading.value = false;
          },
          onError: (error) {
            isLoading.value = false;
          },
        );
  }

  /// Creates a new anonymous Client Reference Record in Firestore
  Future<bool> createClientRecord(String clientCode) async {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Please log in to save client records');
      return false;
    }

    try {
      isLoading.value = true;
      final newRecord = ClientRecordModel(
        clientCode: clientCode,
        userId: uid,
        createdAt: DateTime.now(),
        sessions: [],
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('client_records')
          .doc(clientCode)
          .set(newRecord.toMap());

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to create client reference: $e');
      return false;
    }
  }

  /// Appends a new session to an existing Client Reference Record
  Future<bool> addSessionToRecord({
    required String clientCode,
    required List<String> modulesUsed,
    required List<String> wellnessConcerns,
    required List<String> energeticPatterns,
  }) async {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Please log in to save session records');
      return false;
    }

    try {
      isLoading.value = true;
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('client_records')
          .doc(clientCode);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        isLoading.value = false;
        Get.snackbar('Error', 'Client Reference Code ($clientCode) not found.');
        return false;
      }

      final existingRecord = ClientRecordModel.fromMap(docSnapshot.data()!);
      final nextSequence = existingRecord.sessions.length + 1;

      final newSession = SessionModel(
        sessionSequence: nextSequence,
        modulesUsed: modulesUsed,
        wellnessConcerns: wellnessConcerns,
        energeticPatterns: energeticPatterns,
        timestamp: DateTime.now(),
      );

      final updatedSessions = [...existingRecord.sessions, newSession];

      await docRef.update({
        'sessions': updatedSessions.map((s) => s.toMap()).toList(),
      });

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to add session: $e');
      return false;
    }
  }

  /// Permanently deletes a Client Reference Record
  Future<bool> deleteClientRecord(String clientCode) async {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) return false;

    try {
      isLoading.value = true;
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('client_records')
          .doc(clientCode)
          .delete();

      isLoading.value = false;
      Get.snackbar('Success', 'Client Reference $clientCode deleted.');
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete record: $e');
      return false;
    }
  }

  /// Generates formatted share text for a session with month/year, marketing message, URLs, and FDA disclaimer
  String generateShareableText({
    required String clientCode,
    required SessionModel session,
  }) {
    final monthYear = DateFormat('MMMM yyyy').format(session.timestamp);
    final buffer = StringBuffer();

    buffer.writeln('--- AO SCAN SESSION REPORT ---');
    buffer.writeln('Client Reference Code: $clientCode');
    buffer.writeln('Session: #${session.sessionSequence} ($monthYear)');
    buffer.writeln();

    if (session.modulesUsed.isNotEmpty) {
      buffer.writeln('• AO Scan Modules Used:');
      for (var mod in session.modulesUsed) {
        buffer.writeln('  - $mod');
      }
      buffer.writeln();
    }

    if (session.wellnessConcerns.isNotEmpty) {
      buffer.writeln('• Wellness Concerns Reported:');
      for (var concern in session.wellnessConcerns) {
        buffer.writeln('  - $concern');
      }
      buffer.writeln();
    }

    if (session.energeticPatterns.isNotEmpty) {
      buffer.writeln('• Energetic Expression Patterns Noted:');
      final Map<String, List<String>> grouped = {};
      for (var pattern in session.energeticPatterns) {
        final cat = RecordsConstants.getCategoryForPattern(pattern);
        grouped.putIfAbsent(cat, () => []).add(pattern);
      }
      grouped.forEach((category, items) {
        buffer.writeln('  [$category]');
        for (var item in items) {
          buffer.writeln('    - $item');
        }
      });
      buffer.writeln('(${RecordsConstants.energeticDisclaimer})');
      buffer.writeln();
    }

    buffer.writeln(RecordsConstants.marketingHookText);
    buffer.writeln('Website: ${RecordsConstants.websiteUrl}');
    buffer.writeln('Shop: ${RecordsConstants.shopUrl}');
    buffer.writeln();
    buffer.writeln(RecordsConstants.fdaDisclaimer);

    return buffer.toString();
  }

  /// Copies formatted share text to clipboard
  Future<void> copyShareTextToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied!',
      'Report copied to clipboard. Ready to share.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Opens native OS sharing dialog via share_plus
  Future<void> shareTextNative(String text) async {
    await Share.share(text);
  }

  /// Calculates total sessions logged across all client records for dashboard counter
  int get totalSessionsCount {
    int total = 0;
    for (var record in clientRecords) {
      total += record.sessions.length;
    }
    return total;
  }
}
