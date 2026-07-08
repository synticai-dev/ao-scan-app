import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────
// Data model for each informational page
// ─────────────────────────────────────────────────────────────
class _DemoInfoPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final String blogUrl;
  final List<Widget> Function(BuildContext context) contentBuilder;

  const _DemoInfoPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.blogUrl,
    required this.contentBuilder,
  });
}

// ─────────────────────────────────────────────────────────────
// Static content pages
// ─────────────────────────────────────────────────────────────
final List<_DemoInfoPage> _pages = [
  _DemoInfoPage(
    title: 'About Your AO Scan Demo',
    subtitle: 'What was included in your demo experience',
    icon: Icons.info_outline_rounded,
    iconBg: const Color(0xFF3A53A3),
    blogUrl: 'https://aoscanglobal.com/about-your-ao-scan-demo/',
    contentBuilder: (ctx) => _buildPage1Content(),
  ),
  _DemoInfoPage(
    title: 'How Does the AO Scan Demo Work?',
    subtitle: 'The technology behind your scan',
    icon: Icons.science_rounded,
    iconBg: const Color(0xFF059669),
    blogUrl: 'https://aoscanglobal.com/how-does-the-ao-scan-demo-work/',
    contentBuilder: (ctx) => _buildPage2Content(),
  ),
  _DemoInfoPage(
    title: 'Frequently Asked Questions',
    subtitle: 'Common questions about AO Scan',
    icon: Icons.help_outline_rounded,
    iconBg: const Color(0xFFD97706),
    blogUrl:
        'https://aoscanglobal.com/ao-scan-demo-frequently-asked-questions/',
    contentBuilder: (ctx) => _buildPage3Content(),
  ),
  _DemoInfoPage(
    title: 'Ready to Talk with a Specialist?',
    subtitle: 'Get in touch with our team',
    icon: Icons.support_agent_rounded,
    iconBg: const Color(0xFF7C3AED),
    blogUrl:
        'https://aoscanglobal.com/ready-to-talk-with-an-ao-scan-specialist-ao-scan-global-companion-app-answer/',
    contentBuilder: (ctx) => _buildPage4Content(),
  ),
];

// ═════════════════════════════════════════════════════════════
//  MENU SCREEN
// ═════════════════════════════════════════════════════════════
class AboutDemoMenuScreen extends StatelessWidget {
  const AboutDemoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4FD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'About Your AO Scan Demo',
          style: AppTextStyle.bold(fontSize: 18, color: AppColors.darkBlue),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header blurb
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E2F66), Color(0xFF3A53A3)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Thank you for exploring AO Scan technology.',
                    style: AppTextStyle.bold(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Whether you\'re integrating AO Scan into your clinic, office, spa, gym, car, or your home whether in the U.S. or globally our technology works seamlessly on your tablet, PC, or phone.',
                    style: AppTextStyle.regular(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu cards
            ...List.generate(_pages.length, (i) {
              final page = _pages[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MenuCard(
                  page: page,
                  onTap: () =>
                      Get.to(() => AboutDemoDetailScreen(pageIndex: i)),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Contact section
            _ContactSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final _DemoInfoPage page;
  final VoidCallback onTap;

  const _MenuCard({required this.page, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: page.iconBg.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(page.icon, color: page.iconBg, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: AppTextStyle.bold(
                      fontSize: 15,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    page.subtitle,
                    style: AppTextStyle.regular(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textLight,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  CONTACT SECTION (reused in menu and detail pages)
// ═════════════════════════════════════════════════════════════
class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions? We\'re here to help.',
            style: AppTextStyle.bold(fontSize: 16, color: AppColors.darkBlue),
          ),
          const SizedBox(height: 16),
          _contactTile(
            icon: Icons.email_outlined,
            color: const Color(0xFF3A53A3),
            label: 'Contact Support',
            subtitle: 'info@aoscanglobal.com',
            onTap: () async {
              try {
                final uri = Uri(
                  scheme: 'mailto',
                  path: 'info@aoscanglobal.com',
                );
                if (!await launchUrl(uri)) {
                  Get.snackbar(
                    'Email',
                    'info@aoscanglobal.com',
                    snackPosition: SnackPosition.BOTTOM,
                    messageText: Text(
                      'Email us at info@aoscanglobal.com',
                      style: AppTextStyle.regular(fontSize: 14),
                    ),
                  );
                }
              } catch (_) {
                Get.snackbar(
                  'Email',
                  'info@aoscanglobal.com',
                  snackPosition: SnackPosition.BOTTOM,
                  messageText: Text(
                    'Email us at info@aoscanglobal.com',
                    style: AppTextStyle.regular(fontSize: 14),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _contactTile(
            icon: Icons.chat_rounded,
            color: const Color(0xFF25D366),
            label: 'Contact via WhatsApp',
            subtitle: 'Message us directly',
            onTap: () async {
              try {
                final uri = Uri.parse('https://wa.me/message/PEDHEKESXENHM1');
                if (!await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                )) {
                  Get.snackbar(
                    'WhatsApp',
                    'Could not open WhatsApp',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              } catch (_) {
                Get.snackbar(
                  'WhatsApp',
                  'Could not open WhatsApp',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _contactTile(
            icon: Icons.language_rounded,
            color: const Color(0xFF059669),
            label: 'Visit AOScanGlobal.com',
            subtitle: 'Educational information & resources',
            onTap: () async {
              try {
                final uri = Uri.parse('https://www.aoscanglobal.com');
                if (!await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                )) {
                  Get.snackbar(
                    'Website',
                    'Could not open browser',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              } catch (_) {
                Get.snackbar(
                  'Website',
                  'Could not open browser',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Copyright © 2026 AO Scan Global. All rights reserved.',
              style: AppTextStyle.regular(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required Color color,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.bold(
                      fontSize: 14,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyle.regular(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  DETAIL SCREEN
// ═════════════════════════════════════════════════════════════
class AboutDemoDetailScreen extends StatelessWidget {
  final int pageIndex;
  const AboutDemoDetailScreen({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final page = _pages[pageIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4FD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          page.title,
          style: AppTextStyle.bold(fontSize: 16, color: AppColors.darkBlue),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: page.iconBg.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(page.icon, color: page.iconBg, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bold(
                      fontSize: 20,
                      color: AppColors.darkBlue,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: page.contentBuilder(context),
              ),
            ),
            const SizedBox(height: 20),

            // Read Full Article button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final uri = Uri.parse(page.blogUrl);
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      Get.snackbar(
                        'Browser',
                        'Could not open the article',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } catch (_) {
                    Get.snackbar(
                      'Browser',
                      'Could not open the article',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Read Full Article on Website'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact section
            _ContactSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  HELPER WIDGETS for content
// ═════════════════════════════════════════════════════════════
Widget _heading(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      text,
      style: AppTextStyle.bold(
        fontSize: 17,
        color: AppColors.darkBlue,
        height: 1.3,
      ),
    ),
  );
}

Widget _body(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: AppTextStyle.regular(
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
    ),
  );
}

Widget _bullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.regular(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _quote(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF6FF),
      borderRadius: BorderRadius.circular(12),
      border: const Border(
        left: BorderSide(color: AppColors.primaryBlue, width: 3),
      ),
    ),
    child: Text(
      '"$text"',
      style: AppTextStyle.bold(
        fontSize: 14,
        color: AppColors.darkBlue,
        height: 1.5,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

// ═════════════════════════════════════════════════════════════
//  PAGE 1: About Your AO Scan Demo
// ═════════════════════════════════════════════════════════════
List<Widget> _buildPage1Content() {
  return [
    _body('Thank you for requesting an AO Scan demo.'),
    _body(
      'Your demo was provided as an educational experience designed to help you explore energetic wellness patterns and learn more about AO Scan technology.',
    ),
    _body(
      'Depending on practitioner availability and your interests, your demo may have included one or more of the following:',
    ),
    _bullet('Inner Voice'),
    _bullet('Vitals'),
    _bullet('Comprehensive'),
    _bullet('Body Systems'),
    _body(
      'AO Scan compares energetic patterns against a large library of frequency blueprints and generates educational wellness reports. The technology is not intended to diagnose, treat, cure, or prevent disease.',
    ),

    _heading('Was My Scan Performed Remotely?'),
    _body('Yes.'),
    _body(
      'AO Scan can be used remotely or in person. Demos are generally performed remotely using the information you provided when requesting your scan.',
    ),
    _body(
      'In-person scans are typically performed using AO Scan\'s specialized bone-conduction headset and additional accessories.',
    ),

    _heading('What Do My Results Mean?'),
    _body(
      'Your results are provided for self-exploration and educational purposes.',
    ),
    _body('The purpose of the free demo is to help you understand:'),
    _bullet('How AO Scan works'),
    _bullet('What epigenetic factors might be impacting your body field'),
    _bullet('What information the reports contain'),
    _bullet('How optimization functions work'),
    _bullet('How practitioners use the technology'),
    _bullet('How AO Scan may be used at home or in a wellness practice'),
    _body(
      'The free demo is not intended to provide individualized interpretations of your scan findings.',
    ),

    _heading('There Is Much More To AO Scan'),
    _body(
      'Many people are surprised to learn that the demo only introduces a small portion of the AO Scan platform.',
    ),
    _body('Additional features include:'),
    _bullet('SEFI frequency programs'),
    _bullet('AO MindSync'),
    _bullet('Quick Scan'),
    _bullet('Multiscan'),
    _bullet('Multicast'),
    _bullet('Pet Scans'),
    _bullet('Wellness optimization tools'),

    _heading('Why We Offer Free Demos'),
    _body('Our goal is simple.'),
    _body(
      'We want people to have the opportunity to view their bodies through an energetic lens and become more aware of the patterns influencing their wellness journeys.',
    ),
    _body('The demo is the beginning.'),
    _body('What you learn and do afterward is where the real value begins.'),
  ];
}

// ═════════════════════════════════════════════════════════════
//  PAGE 2: How Does the AO Scan Demo Work?
// ═════════════════════════════════════════════════════════════
List<Widget> _buildPage2Content() {
  return [
    _body('Many people receive their AO Scan demo and immediately ask:'),
    _quote('How does this technology actually work?'),
    _body(
      'The simple answer is that AO Scan is an educational frequency technology designed to help users (or health professionals) explore energetic wellness patterns and trends over time.',
    ),
    _body(
      'An exact, more complex answer lies somewhere in the fields of radionics and quantum physics.',
    ),

    _heading('How Is An AO Scan Performed?'),
    _body(
      'Before a scan begins, a client profile is created using information such as:',
    ),
    _bullet('Name'),
    _bullet('Email'),
    _bullet('Height'),
    _bullet('Weight'),
    _bullet('Birth date'),
    _bullet('Voice recording'),
    _bullet('Optional photo'),
    _body(
      'This profile is used to generate personalized educational wellness reports. Our AO Scan practitioners and users often explain that establishing a client profile creates an energetic signature unique to that person in the quantum field to which we send the frequencies.',
    ),

    _heading('Can an AO Scan Be Used Remotely and In Person?'),
    _body('Yes.'),
    _body('In fact, your demo with AO Scan Global was performed remotely.'),
    _body(
      'AO Scan can be used remotely or in person, allowing practitioners, wellness professionals, and users to connect regardless of location. Wi-Fi is necessary when using the software.',
    ),
    _body(
      'Many users appreciate the convenience of remote scanning because no travel or office visit is required.',
    ),
    _body(
      'Other individuals, clinics, spas, etc., prefer in-person scanning when the system leverages a specially-tuned bone conduction headset where audible and inaudible frequencies can be heard and felt.',
    ),

    _heading('What Is AO Scan Looking At?'),
    _body('AO Scan compares more than:'),
    _bullet('170,000 energetic points on the body'),
    _bullet('120,000+ blueprint frequencies'),
    _body(
      'The goal is not to diagnose disease. Instead, the technology helps users explore energetic patterns, wellness trends, and areas that may deserve closer attention.',
    ),

    _heading('What Reports Might I Have Received?'),
    _body('Your demo may have included:'),
    _bullet('Inner Voice'),
    _bullet('Vitals'),
    _bullet('Comprehensive'),
    _bullet('Body Systems'),
    _body(
      'Not every demo includes all four scans, but these are the most common introductory reports.',
    ),

    _heading('What Do The Numbers Mean?'),
    _body('Many AO Scan reports display values from 1\u20139.'),
    _body('Generally speaking:'),
    _bullet('Lower values may indicate lower energetic activity'),
    _bullet('Mid-range values often suggest balance and adaptation'),
    _bullet('Higher values may indicate increased energetic activity'),
    _body(
      'A bit more goes into the values shown on your scan, but that can be better understood once you start exploring the training and resources available.',
    ),
    _body('The most important takeaway is this:'),
    _body('Don\'t focus on a single number. Look for patterns over time.'),

    _heading('Why Patterns Matter'),
    _body('A single scan is only a snapshot.'),
    _body('Your body changes daily based on:'),
    _bullet('Sleep'),
    _bullet('Stress'),
    _bullet('Hydration'),
    _bullet('Nutrition'),
    _bullet('Environment'),
    _bullet('Lifestyle choices'),
    _body(
      'That is why experienced AO Scan users focus on recurring patterns rather than individual results.',
    ),
    _quote('Scan and Know.'),
  ];
}

// ═════════════════════════════════════════════════════════════
//  PAGE 3: Frequently Asked Questions
// ═════════════════════════════════════════════════════════════
List<Widget> _buildPage3Content() {
  return [
    _body(
      'It\'s completely normal to have questions after receiving your AO Scan demo.',
    ),
    _body(
      'AO Scan introduces concepts that many people have never encountered before, including frequency technology, energetic quantum physics, wellness patterns, remote scanning, and optimization sessions.',
    ),
    _body(
      'The good news is that you do not need to understand everything immediately. Many users begin by simply exploring their reports and learning more over time.',
    ),

    _heading('Can Beginners Use AO Scan?'),
    _body('Absolutely.'),
    _body(
      'AO Scan was designed for both beginners and experienced practitioners. Users include:',
    ),
    _bullet('Parents'),
    _bullet('Wellness enthusiasts'),
    _bullet('Biohackers'),
    _bullet('Coaches'),
    _bullet('Massage therapists'),
    _bullet('Chiropractors'),
    _bullet('Naturopaths'),
    _bullet('Functional Medical Doctors'),
    _bullet('Wellness professionals'),
    _body('You can start simple and learn at your own pace.'),

    _heading('Do I Need A Medical Background?'),
    _body('No.'),
    _body('Many AO Scan users have no healthcare training at all.'),
    _body(
      'At the same time, practitioners and wellness professionals often appreciate the technology because it provides another way to explore wellness patterns and support client education.',
    ),

    _heading('Is Training Available?'),
    _body('Yes.'),
    _body(
      'AO Scan users have access to a wide variety of educational resources, including:',
    ),
    _bullet('Blog articles (20+ languages)'),
    _bullet('Video tutorials'),
    _bullet('Weekly educational calls'),
    _bullet('User communities'),
    _bullet('Practitioner support'),
    _bullet('AO Scan Global educational content'),
    _bullet('Social media updates'),
    _bullet('Customer support resources'),

    _heading('What Happens After My Demo?'),
    _body('That depends on your goals.'),
    _body('Some people simply enjoy learning about wellness technology.'),
    _body('Others request additional scans.'),
    _body(
      'Many continue exploring AO Scan because they want ongoing access to scans, reports, optimizations, and educational wellness tools.',
    ),
    _body('There is no right or wrong next step.'),

    _heading('Where Can I Learn More?'),
    _body('We recommend:'),
    _bullet('Reading our complete FAQ library'),
    _bullet('Searching the AO Scan Global blog'),
    _bullet('Watching educational videos'),
    _bullet('Contacting AO Scan Global directly'),
    _body(
      'Most importantly, stay curious and focus on patterns rather than individual data points.',
    ),
    _body(
      'Over time, the reports become easier to understand and more meaningful.',
    ),
    _quote('Scan and Know.'),
  ];
}

// ═════════════════════════════════════════════════════════════
//  PAGE 4: Ready to Talk with a Specialist?
// ═════════════════════════════════════════════════════════════
List<Widget> _buildPage4Content() {
  return [
    _body('Thank you for participating in our AO Scan demo program.'),
    _body(
      'We know AO Scan technology often sparks new questions. Many people receive their first demo and immediately want to learn more about frequency technology, wellness patterns, reports, optimizations, and how the technology can be used in everyday life.',
    ),
    _body('That\'s exactly why we\'re here.'),

    _heading('Why We Offer Free Demos'),
    _body('The purpose of a demo is not simply to generate a report.'),
    _body(
      'Our goal is to help people better understand their bodies through an energetic lens and introduce them to wellness tools that may support greater awareness and self-discovery.',
    ),
    _body('For many people, the demo is their first introduction to:'),
    _bullet('Frequency technology'),
    _bullet('Energetic wellness patterns'),
    _bullet('Inner Voice'),
    _bullet('SEFI programs'),
    _bullet('AO MindSync'),
    _bullet('Quick Scan (supplement recommendations based on frequency)'),
    _bullet('Wellness optimization tools'),
    _bullet('Educational wellness reports'),

    _heading('Every User\'s Journey Is Different'),
    _body('Some people explore AO Scan for personal wellness. Others are:'),
    _bullet('Parents'),
    _bullet('Doctors'),
    _bullet('Wellness enthusiasts'),
    _bullet('Biohackers'),
    _bullet('Coaches'),
    _bullet('Massage therapists'),
    _bullet('Chiropractors'),
    _bullet('Naturopaths'),
    _bullet('Personal trainers'),
    _bullet('Wellness practitioners'),
    _body('Many people also use AO Scan with family members and pets.'),
    _body('There is no single path and no single way to use the technology.'),

    _heading('What Can We Help You With?'),
    _body('We frequently answer questions about:'),
    _bullet('How AO Scan works'),
    _bullet('Remote versus in-person scanning'),
    _bullet('Setting up a health and wellness practice'),
    _bullet('Reports and optimizations'),
    _bullet('Additional educational scans'),
    _bullet('Affiliate opportunity'),
    _bullet('Training resources'),
    _bullet('Wellness applications'),
    _bullet('Family and pet scanning'),
    _bullet('SEFI programs'),
    _bullet('AO MindSync'),
    _bullet('Quick Scan'),
    _bullet('Multiscan'),
    _bullet('Multicast'),
    _body(
      'If you\'re wondering whether AO Scan is right for you, your family, or your wellness practice, we\'d be happy to help.',
    ),

    _heading('The Demo Is Only The Beginning'),
    _body(
      'Many people are surprised to discover how much more AO Scan offers beyond the reports included in a demonstration.',
    ),
    _body(
      'The free demo is designed to introduce the technology and help you decide what you\'d like to explore next.',
    ),
    _body(
      'Most importantly, we want you to feel comfortable asking questions and continuing your learning journey.',
    ),
  ];
}
