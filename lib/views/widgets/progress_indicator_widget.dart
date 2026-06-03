import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber <= currentStep;

        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: isActive
                      ? AppColors.progressActive
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? AppColors.buttonTextWhite
                        : AppColors.backgroundWhite,
                    width: 6,
                  ),
                  color: isActive
                      ? AppColors.progressActive
                      : Colors.grey.shade300,
                ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 30,
                height: 2,
                color: isActive
                    ? AppColors.progressActive
                    : AppColors.progressInactive,
              ),
          ],
        );
      }),
    );
  }
}
