import 'package:ao_scan_app/controllers/resources_controller.dart';
import 'package:ao_scan_app/models/resource_model.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourceDetailScreen extends StatelessWidget {
  final ResourceModel resource;
  ResourceDetailScreen({super.key, required this.resource});

  final controller = Get.find<ResourcesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primaryBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              Obx(() => IconButton(
                    icon: Icon(
                      controller.isFavorite(resource.id)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () => controller.toggleFavorite(resource.id),
                  )),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: resource.imageUrl != null
                  ? Image.network(resource.imageUrl!, fit: BoxFit.cover)
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryBlue, AppColors.darkBlue],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.menu_book, size: 80, color: Colors.white24),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      resource.category.toUpperCase(),
                      style: AppTextStyle.bold(fontSize: 12, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    resource.title,
                    style: AppTextStyle.bold(fontSize: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resource.description,
                    style: AppTextStyle.regular(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.borderLight),
                  const SizedBox(height: 24),
                  Text(
                    resource.content,
                    style: AppTextStyle.regular(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
