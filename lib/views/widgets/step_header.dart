import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import 'progress_indicator_widget.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const StepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          if (onBack != null)
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Step $currentStep of $totalSteps',
                    style: AppTextStyle.bold(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressIndicatorWidget(
            currentStep: currentStep,
            totalSteps: totalSteps,
          ),
        ],
      ),
    );
  }
}
