import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/records_controller.dart';
import '../../../utils/app_colors.dart';
import 'create_client_reference_screen.dart';
import 'add_session_screen.dart';
import 'client_history_screen.dart';

class AoScanRecordsMainScreen extends StatelessWidget {
  const AoScanRecordsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecordsController recordsController = Get.put(RecordsController());
    final TextEditingController searchCodeController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'AO Scan Records',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (recordsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner / Action Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.folder_shared_rounded,
                        size: 48,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Anonymous AO Scan Session Tracker',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Log and track client wellness scan sessions using secure, anonymous Client Reference Codes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => const CreateClientReferenceScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 15, color: Colors.white),
                              children: [
                                TextSpan(
                                  text: '+Create ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: 'New Client Reference Code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          _showSearchDialog(
                            context,
                            recordsController,
                            searchCodeController,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.playlist_add,
                          color: AppColors.primaryBlue,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 15, color: AppColors.primaryBlue),
                              children: [
                                TextSpan(
                                  text: '+Add ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: 'AO Scan Session to Existing Client Reference Code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Saved Records Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Client References',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${recordsController.clientRecords.length} Saved',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List of Saved Client Code Cards
              if (recordsController.clientRecords.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: const [
                      Icon(
                        Icons.privacy_tip_outlined,
                        size: 40,
                        color: AppColors.textLight,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No client reference codes yet.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap "Create New Client Reference" above to start.',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recordsController.clientRecords.length,
                  itemBuilder: (context, index) {
                    final record = recordsController.clientRecords[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryBlue.withOpacity(
                            0.1,
                          ),
                          child: const Icon(
                            Icons.qr_code,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        title: Text(
                          record.clientCode,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          '${record.sessions.length} Session(s) logged',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_task,
                                color: AppColors.primaryBlue,
                              ),
                              tooltip: 'Add Session',
                              onPressed: () {
                                Get.to(
                                  () => AddSessionScreen(
                                    clientCode: record.clientCode,
                                  ),
                                );
                              },
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textLight,
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(
                            () => ClientHistoryScreen(clientRecord: record),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  void _showSearchDialog(
    BuildContext context,
    RecordsController controller,
    TextEditingController textController,
  ) {
    textController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Client Code'),
          content: TextField(
            controller: textController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: 'e.g. AO-7K4P9M2Q',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = textController.text.trim().toUpperCase();
                if (code.isNotEmpty) {
                  Navigator.pop(context);
                  Get.to(() => AddSessionScreen(clientCode: code));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
