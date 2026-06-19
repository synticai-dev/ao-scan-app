import 'package:ao_scan_app/controllers/auth_controller.dart';
import 'package:ao_scan_app/models/demo_request_model.dart';
import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:ao_scan_app/views/screens/auth/login_screen.dart';
import 'package:ao_scan_app/views/screens/demo_form_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ao_scan_app/views/screens/webview_screen.dart';
import 'package:ao_scan_app/views/screens/demo_request_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final authController = Get.find<AuthController>();

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final uri = Uri.parse(
            'https://tawk.to/chat/647b63247957702c744b9614/1h20vmhkl',
          );
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch Tawk chat';
          }
        },
        backgroundColor: const Color(0xFF059669),
        elevation: 4,
        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ),
      body: Obx(() {
        if (!authController.isLoggedIn) return _loginRequired();
        final user = authController.userModel.value;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroHeader(user, context),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statsRow(user?.uid ?? ''),
                    const SizedBox(height: 24),
                    _profileCard(user),
                    const SizedBox(height: 24),
                    _requestsSection(),
                    const SizedBox(height: 24),
                    _bookDemoBanner(),
                    const SizedBox(height: 24),
                    _footer(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── HERO HEADER ─────────────────────────────────────────────
  Widget _heroHeader(dynamic user, BuildContext context) {
    final name = user?.name ?? 'User';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final email = user?.email ?? '';

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(48),
        bottomRight: Radius.circular(48),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E2F66), Color(0xFF2C43A0), Color(0xFF3A53A3)],
          ),
        ),
        child: Stack(
          children: [
            // Mesh Gradient Style Blobs
            Positioned(
              top: -60,
              right: -40,
              child: _buildDecorativeBlob(
                size: 220,
                color: const Color(0xFF6366F1).withOpacity(0.15),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -30,
              child: _buildDecorativeBlob(
                size: 180,
                color: const Color(0xFFEC4899).withOpacity(0.08),
              ),
            ),
            Positioned(
              top: 40,
              left: 40,
              child: _buildDecorativeBlob(
                size: 80,
                color: Colors.white.withOpacity(0.04),
              ),
            ),

            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                child: Column(
                  children: [
                    // Top Navigation Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGlassButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Get.back(),
                        ),
                        Text(
                          'DASHBOARD',
                          style: AppTextStyle.bold(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ).copyWith(letterSpacing: 2),
                        ),
                        _buildGlassButton(
                          icon: Icons.power_settings_new_rounded,
                          onTap: _confirmLogout,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Premium Avatar with Glowing Ring
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFFEC4899),
                              Color(0xFF3A53A3),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1E2F66),
                          ),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: const Color(0xFF2C43A0),
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Dynamic Greeting & Name
                    Column(
                      children: [
                        Text(
                          _greeting().toUpperCase(),
                          style: AppTextStyle.bold(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.5),
                          ).copyWith(letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: AppTextStyle.bold(
                            fontSize: 28,
                            color: Colors.white,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Glassmorphic Email Chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        email,
                        style: AppTextStyle.regular(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Premium Quick Action Pill
                    GestureDetector(
                      onTap: () => Get.to(() => const DemoFormScreen()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'REQUEST FREE DEMO',
                              style: AppTextStyle.bold(
                                fontSize: 13,
                                color: Colors.white,
                              ).copyWith(letterSpacing: 0.5),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white.withOpacity(0.5),
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 18),
      ),
    );
  }

  Widget _buildDecorativeBlob({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  // ── STATS ROW ───────────────────────────────────────────────
  Widget _statsRow(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('demo_requests')
          .where('userId', isEqualTo: uid)
          .snapshots(),
      builder: (context, snap) {
        int total = 0, approved = 0, pending = 0;
        if (snap.hasData) {
          total = snap.data!.docs.length;
          for (final d in snap.data!.docs) {
            final s =
                (d.data() as Map)['status']?.toString().toLowerCase() ?? '';
            if (s == 'approved') approved++;
            if (s == 'pending') pending++;
          }
        }
        return Row(
          children: [
            Expanded(
              child: _statChip('$total', 'Total', const Color(0xFF3A53A3)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statChip(
                '$approved',
                'Approved',
                const Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statChip('$pending', 'Pending', const Color(0xFFD97706)),
            ),
          ],
        );
      },
    );
  }

  Widget _statChip(String value, String label, Color dotColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: AppTextStyle.bold(
                  fontSize: 22,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.regular(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── PROFILE CARD ────────────────────────────────────────────
  Widget _profileCard(dynamic user) {
    if (user == null) return const SizedBox.shrink();
    final fields = <_Field>[];
    if ((user.occupation ?? '').isNotEmpty)
      fields.add(
        _Field(
          Icons.work_rounded,
          'Occupation',
          user.occupation!,
          const Color(0xFF6366F1),
          const Color(0xFFEEF2FF),
        ),
      );
    if ((user.country ?? '').isNotEmpty)
      fields.add(
        _Field(
          Icons.language_rounded,
          'Country',
          user.country!,
          const Color(0xFF3A53A3),
          const Color(0xFFEFF6FF),
        ),
      );
    if ((user.phoneNumber ?? '').isNotEmpty)
      fields.add(
        _Field(
          Icons.phone_rounded,
          'Phone',
          user.phoneNumber!,
          const Color(0xFF059669),
          const Color(0xFFECFDF5),
        ),
      );
    if ((user.sex ?? '').isNotEmpty)
      fields.add(
        _Field(
          Icons.person_rounded,
          'Sex',
          user.sex!,
          const Color(0xFF8B5CF6),
          const Color(0xFFF5F3FF),
        ),
      );
    if ((user.dob ?? '').isNotEmpty)
      fields.add(
        _Field(
          Icons.calendar_month_rounded,
          'Date of Birth',
          user.dob!,
          const Color(0xFFDC2626),
          const Color(0xFFFFF1F2),
        ),
      );
    if (fields.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Text(
              'My Profile',
              style: AppTextStyle.bold(fontSize: 16, color: AppColors.darkBlue),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: fields.map((f) => _profileRow(f)).toList()),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(_Field f) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: f.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(f.icon, color: f.color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              f.label,
              style: AppTextStyle.regular(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Flexible(
            child: Text(
              f.value,
              textAlign: TextAlign.right,
              style: AppTextStyle.bold(fontSize: 14, color: AppColors.darkBlue),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── REQUESTS SECTION ────────────────────────────────────────
  Widget _requestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Requests',
          style: AppTextStyle.bold(fontSize: 17, color: AppColors.darkBlue),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('demo_requests')
              .where(
                'userId',
                isEqualTo: authController.firebaseUser.value?.uid,
              )
              .snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryBlue,
                  ),
                ),
              );
            }
            if (!snap.hasData || snap.data!.docs.isEmpty) return _emptyState();
            final docs = snap.data!.docs;
            final count = docs.length > 3 ? 3 : docs.length;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: count,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final data = docs[i].data() as Map<String, dynamic>;
                data['id'] = docs[i].id;
                return _requestCard(DemoRequestModel.fromMap(data));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 30,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No Requests Yet',
            style: AppTextStyle.bold(fontSize: 15, color: AppColors.darkBlue),
          ),
          const SizedBox(height: 6),
          Text(
            'You haven\'t made any demo requests yet.',
            textAlign: TextAlign.center,
            style: AppTextStyle.regular(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestCard(DemoRequestModel request) {
    Color statusColor;
    String statusLabel;
    switch (request.status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF059669);
        statusLabel = 'Approved';
        break;
      case 'rejected':
        statusColor = const Color(0xFFDC2626);
        statusLabel = 'Declined';
        break;
      default:
        statusColor = const Color(0xFFD97706);
        statusLabel = 'Pending';
    }
    return GestureDetector(
      onTap: () => Get.to(() => DemoRequestDetailsScreen(request: request)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // left status bar
            Container(
              width: 4,
              height: 64,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AO Scan Demo',
                    style: AppTextStyle.bold(
                      fontSize: 14,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('MMM dd, yyyy').format(request.submissionDate),
                    style: AppTextStyle.regular(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusLabel,
                style: AppTextStyle.bold(fontSize: 11, color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── BOOK DEMO BANNER ────────────────────────────────────────
  Widget _bookDemoBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2F66),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a Demo',
                  style: AppTextStyle.bold(fontSize: 17, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Experience AO Scan technology firsthand.',
                  style: AppTextStyle.regular(
                    fontSize: 12,
                    color: Colors.white60,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Get.to(() => const DemoFormScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E2F66),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Book Now',
              style: AppTextStyle.bold(
                fontSize: 13,
                color: const Color(0xFF1E2F66),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FOOTER ──────────────────────────────────────────────────
  Widget _footer(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fLink(
              'Privacy Policy',
              () => Get.to(
                () => const WebViewScreen(
                  url: 'https://www.iubenda.com/privacy-policy/65675001/legal',
                  title: 'Privacy Policy',
                ),
              ),
            ),
            Text(
              '  •  ',
              style: AppTextStyle.regular(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
            _fLink(
              'Delete Account',
              () => _confirmDelete(context),
              color: AppColors.errorRed,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'AO Scan Global • v1.0.0',
          style: AppTextStyle.regular(fontSize: 11, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _fLink(String label, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyle.regular(
          fontSize: 13,
          color: color ?? AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── LOGIN REQUIRED ──────────────────────────────────────────
  Widget _loginRequired() {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: 20,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 48,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Sign In Required',
                style: AppTextStyle.bold(
                  fontSize: 22,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please sign in to access your personal dashboard.',
                textAlign: TextAlign.center,
                style: AppTextStyle.regular(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => LoginScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: AppTextStyle.bold(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── DIALOGS ─────────────────────────────────────────────────
  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.darkBlue),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTextStyle.regular(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyle.bold(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await authController.logout();
            },
            child: Text(
              'Logout',
              style: AppTextStyle.bold(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.errorRed),
        ),
        content: Text(
          'This permanently deletes your account and all data.',
          style: AppTextStyle.regular(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyle.bold(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await authController.deleteAccount();
            },
            child: Text(
              'Delete',
              style: AppTextStyle.bold(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bg;
  _Field(this.icon, this.label, this.value, this.color, this.bg);
}
