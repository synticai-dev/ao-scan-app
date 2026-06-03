import 'package:ao_scan_app/models/demo_request_model.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:ao_scan_app/views/screens/demo_request_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DemoHistoryScreen extends StatelessWidget {
  final String userId;
  const DemoHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Demo History', style: AppTextStyle.bold(fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('demo_requests')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.history_rounded, size: 64, color: AppColors.textLight.withOpacity(0.5)),
                   const SizedBox(height: 16),
                   Text('No history yet', style: AppTextStyle.bold(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              final request = DemoRequestModel.fromMap(data);
              return _buildHistoryCard(request);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(DemoRequestModel request) {
    Color statusColor;
    switch (request.status.toLowerCase()) {
      case 'approved': statusColor = AppColors.successGreen; break;
      case 'rejected': statusColor = AppColors.errorRed; break;
      default: statusColor = AppColors.warningAmber;
    }

    return InkWell(
      onTap: () => Get.to(() => DemoRequestDetailsScreen(request: request)),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                request.status.toLowerCase() == 'approved' ? Icons.check_circle_rounded : Icons.pending_rounded,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demo Request',
                    style: AppTextStyle.bold(fontSize: 16, color: AppColors.darkBlue),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(request.submissionDate),
                    style: AppTextStyle.regular(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request.status.toUpperCase(),
                style: AppTextStyle.bold(fontSize: 10, color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
