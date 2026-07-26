import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/records_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/records_constants.dart';

class AddSessionScreen extends StatefulWidget {
  final String clientCode;

  const AddSessionScreen({super.key, required this.clientCode});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final RecordsController _recordsController = Get.find<RecordsController>();

  final Set<String> _selectedModules = {};
  final Set<String> _selectedConcerns = {};
  final Set<String> _selectedPatterns = {};

  String _concernsSearchQuery = '';
  String _patternsSearchQuery = '';

  final ScrollController _concernsScrollController = ScrollController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _concernsScrollController.dispose();
    super.dispose();
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
        title: Text(
          'Log Session: ${widget.clientCode}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Required Reminder Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.shield_outlined, color: AppColors.primaryBlue, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      RecordsConstants.educationalReminderText,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section 1: Modules Used
            _buildModulesCard(),
            const SizedBox(height: 16),

            // Section 2: Reported Wellness Concerns
            _buildConcernsCard(),
            const SizedBox(height: 16),

            // Section 3: Energetic Expression Patterns Noted (Collapsible Categories)
            _buildEnergeticPatternsCard(),
            const SizedBox(height: 28),

            // Save Session Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _saveSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Session Record',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 1 BUILDER
  // ---------------------------------------------------------------------------
  Widget _buildModulesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Modules Used',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            const Text(
              RecordsConstants.modulesPrompt,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 2),
            const Text(
              RecordsConstants.modulesSubtitle,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const Divider(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: RecordsConstants.modulesUsedList.map((item) {
                final isChecked = _selectedModules.contains(item);
                return FilterChip(
                  label: Text(item),
                  selected: isChecked,
                  selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryBlue,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    color: isChecked ? AppColors.primaryBlue : AppColors.textPrimary,
                    fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedModules.add(item);
                      } else {
                        _selectedModules.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 2 BUILDER
  // ---------------------------------------------------------------------------
  Widget _buildConcernsCard() {
    final filteredItems = RecordsConstants.wellnessConcernsList.where((item) {
      return item.toLowerCase().contains(_concernsSearchQuery.toLowerCase());
    }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2. Reported Wellness Concerns',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                if (_selectedConcerns.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_selectedConcerns.length} selected',
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              RecordsConstants.concernsPrompt,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Text(
                RecordsConstants.concernsSupportingStatement,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search wellness concerns...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                isDense: true,
              ),
              onChanged: (val) {
                setState(() {
                  _concernsSearchQuery = val;
                });
              },
            ),
            const Divider(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: Scrollbar(
                controller: _concernsScrollController,
                thumbVisibility: true,
                radius: const Radius.circular(6),
                child: ListView.builder(
                  controller: _concernsScrollController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isChecked = _selectedConcerns.contains(item);
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primaryBlue,
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          color: isChecked ? AppColors.primaryBlue : AppColors.textPrimary,
                          fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: isChecked,
                      onChanged: (bool? val) {
                        setState(() {
                          if (val == true) {
                            _selectedConcerns.add(item);
                          } else {
                            _selectedConcerns.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 3 BUILDER (Collapsible Categories)
  // ---------------------------------------------------------------------------
  Widget _buildEnergeticPatternsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    '3. Energetic Expression Patterns Noted',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                if (_selectedPatterns.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_selectedPatterns.length} selected',
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              RecordsConstants.energeticPrompt,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Text(
                RecordsConstants.energeticSupportingStatement,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search energetic patterns across categories...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                isDense: true,
              ),
              onChanged: (val) {
                setState(() {
                  _patternsSearchQuery = val;
                });
              },
            ),
            const Divider(height: 20),
            ...RecordsConstants.energeticCategories.entries.map((entry) {
              final categoryName = entry.key;
              final items = entry.value;

              final matchingItems = items.where((item) {
                return item.toLowerCase().contains(_patternsSearchQuery.toLowerCase());
              }).toList();

              if (_patternsSearchQuery.isNotEmpty && matchingItems.isEmpty) {
                return const SizedBox.shrink();
              }

              final selectedCount = items.where((i) => _selectedPatterns.contains(i)).length;

              return Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: _patternsSearchQuery.isNotEmpty,
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    categoryName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                  ),
                  subtitle: Text(
                    '${items.length} options${selectedCount > 0 ? " ($selectedCount selected)" : ""}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  children: matchingItems.map((item) {
                    final isChecked = _selectedPatterns.contains(item);
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 12),
                      activeColor: AppColors.primaryBlue,
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          color: isChecked ? AppColors.primaryBlue : AppColors.textPrimary,
                          fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: isChecked,
                      onChanged: (bool? val) {
                        setState(() {
                          if (val == true) {
                            _selectedPatterns.add(item);
                          } else {
                            _selectedPatterns.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE ACTION
  // ---------------------------------------------------------------------------
  Future<void> _saveSession() async {
    if (_selectedModules.isEmpty && _selectedConcerns.isEmpty && _selectedPatterns.isEmpty) {
      Get.snackbar(
        'Notice',
        'Please select at least one option before saving.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    bool success = await _recordsController.addSessionToRecord(
      clientCode: widget.clientCode,
      modulesUsed: _selectedModules.toList(),
      wellnessConcerns: _selectedConcerns.toList(),
      energeticPatterns: _selectedPatterns.toList(),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      _recordsController.fetchClientRecords();
      Get.back();
      Get.snackbar(
        'Success',
        'Session record saved for ${widget.clientCode}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
