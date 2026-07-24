import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/records_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/records_constants.dart';
import 'add_session_screen.dart';

class CreateClientReferenceScreen extends StatefulWidget {
  const CreateClientReferenceScreen({super.key});

  @override
  State<CreateClientReferenceScreen> createState() =>
      _CreateClientReferenceScreenState();
}

class _CreateClientReferenceScreenState
    extends State<CreateClientReferenceScreen> {
  final RecordsController _recordsController = Get.find<RecordsController>();
  late String _generatedCode;

  @override
  void initState() {
    super.initState();
    _generatedCode = _recordsController.generateClientCode();
  }

  void _regenerateCode() {
    setState(() {
      _generatedCode = _recordsController.generateClientCode();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'New Client Reference',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Code Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Client Reference Code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _generatedCode,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: _generatedCode),
                            );
                            Get.snackbar(
                              'Copied!',
                              'Code $_generatedCode copied to clipboard',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copy Code'),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.primaryBlue,
                          ),
                          tooltip: 'Generate Another Code',
                          onPressed: _regenerateCode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Warning Notice Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningAmber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warningAmber.withOpacity(0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warningAmber,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      RecordsConstants.codeWarningText,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () async {
                bool success = await _recordsController.createClientRecord(
                  _generatedCode,
                );
                if (success) {
                  Get.off(() => AddSessionScreen(clientCode: _generatedCode));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              label: const Text(
                'Save & Continue to Session 1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                bool success = await _recordsController.createClientRecord(
                  _generatedCode,
                );
                if (success) {
                  Get.back();
                }
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Code Only'),
            ),
          ],
        ),
      ),
    );
  }
}
