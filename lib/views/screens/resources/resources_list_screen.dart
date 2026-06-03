import 'package:ao_scan_app/controllers/resources_controller.dart';
import 'package:ao_scan_app/models/resource_model.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:ao_scan_app/views/screens/resources/resource_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourcesListScreen extends StatelessWidget {
  final String? category;
  ResourcesListScreen({super.key, this.category});

  final controller = Get.put(ResourcesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        title: Text(
          category ?? 'Educational Resources',
          style: AppTextStyle.bold(fontSize: 20, color: AppColors.textPrimary),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final filteredResources = category != null
            ? controller.resources.where((r) => r.category == category).toList()
            : controller.resources;

        if (filteredResources.isEmpty) {
          return Center(
            child: Text(
              'No resources found in this category.',
              style: AppTextStyle.regular(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: filteredResources.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final resource = filteredResources[index];
            return _buildResourceCard(resource);
          },
        );
      }),
    );
  }

  Widget _buildResourceCard(ResourceModel resource) {
    return InkWell(
      onTap: () => Get.to(() => ResourceDetailScreen(resource: resource)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  resource.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      resource.category,
                      style: AppTextStyle.bold(fontSize: 10, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resource.title,
                    style: AppTextStyle.bold(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    resource.description,
                    style: AppTextStyle.regular(
                        fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Read More',
                        style: AppTextStyle.bold(fontSize: 14, color: AppColors.primaryBlue),
                      ),
                      Obx(() => IconButton(
                            icon: Icon(
                              controller.isFavorite(resource.id)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: controller.isFavorite(resource.id)
                                  ? AppColors.primaryBlue
                                  : AppColors.textLight,
                            ),
                            onPressed: () => controller.toggleFavorite(resource.id),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
