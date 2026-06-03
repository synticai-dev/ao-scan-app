import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/demo_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../widgets/disclaimer_footer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  final DemoFormController controller = Get.find<DemoFormController>();
  final _formKey = GlobalKey<FormState>();

  AboutScreen({super.key});

  Widget mainHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Text(
        text,
        style: AppTextStyle.bold(fontSize: 22, color: AppColors.buttonPrimary),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  "),
          Expanded(
            child: Text(text, style: AppTextStyle.regular(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(text, style: AppTextStyle.regular(fontSize: 15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              /// HEADER
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "About AO Scan",
                      style: AppTextStyle.bold().copyWith(fontSize: 18),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: 20),

              /// BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Welcome
                        mainHeading("Welcome to Our Quantum Field"),
                        paragraph("Welcome to our quantum field!"),
                        paragraph(
                          "AO Scan by Solex Global is a next-generation frequency wellness system that helps people view the body through an energetic lens.",
                        ),
                        paragraph(
                          "It is used around the world as an educational, non-diagnostic tool by:",
                        ),

                        bullet("Doctors"),
                        bullet("Naturopaths"),
                        bullet("Chiropractors"),
                        bullet("Health Coaches"),
                        bullet("Life Coaches"),
                        bullet("Energy Workers"),
                        bullet("Biohackers"),
                        bullet("Personal Trainers"),
                        bullet("Spa"),
                        bullet("Salon"),
                        bullet("Wellness Enthusiasts"),
                        bullet("Moms and Families"),

                        /// Device Section
                        mainHeading(
                          "Your Device Becomes a Frequency Wellness Tool",
                        ),
                        paragraph(
                          "Instead of buying a room full of devices, you can use your existing:",
                        ),

                        bullet("Phone"),
                        bullet("Tablet"),
                        bullet("Computer"),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyle.regular(fontSize: 15),
                              children: [
                                const TextSpan(
                                  text:
                                      "(An optional bone-conduction headset can also be used with the technology. Most begin with the Starter Pack Bluetooth that can be found ",
                                ),
                                TextSpan(
                                  text: "HERE",
                                  style:
                                      AppTextStyle.regular(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ).copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final url = Uri.parse(
                                        'https://shop.solexnation.com/energy1',
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      }
                                    },
                                ),
                                const TextSpan(text: ")"),
                              ],
                            ),
                          ),
                        ),

                        paragraph(
                          "With your AO Scan subscription, your device becomes your personal:",
                        ),

                        bullet("Energetic Scanner that Assesses and Optimizes"),
                        bullet("Frequency Imprinter"),
                        bullet("Frequency Broadcaster"),

                        /// Library
                        mainHeading("A Powerful Frequency Library"),
                        paragraph(
                          "The AO Scan system includes an extensive library of frequency including:",
                        ),

                        bullet("400+ Homeopathic Remedies"),
                        bullet("Flower Essences"),
                        bullet("Essential Oils"),
                        bullet("Minerals"),
                        bullet("Affirmations"),
                        bullet("Tuning Forks"),
                        bullet("Nosodes"),
                        bullet("Cell Salts"),
                        bullet("Bundled Detoxes"),
                        bullet(
                          "Wellness Protocols (Heavy Metals, Virus, Bacteria, Diabetes, Adrenal/Thyroid, Fungal, Parasite Detox and so much more)",
                        ),
                        bullet("A-to-Z wellness-related patterns"),

                        paragraph(
                          "These can be combined and customized into targeted frequency playlists for personal or clinic use.",
                        ),

                        /// What App Does
                        mainHeading("What the AO Scan App Does"),
                        paragraph(
                          "The AO Scan app analyzes over 170,000+ data points in the body field and compares them to a library of more than 120,000+ reference frequencies. Solex Global takes pride in this expansive frequency list and updates it as our new data warrants.",
                        ),
                        paragraph(
                          "It then generates easy-to-read educational reports to help you better understand energetic patterns related to:",
                        ),

                        bullet("Lifestyle"),
                        bullet("Environment"),
                        bullet("Emotions"),
                        bullet("Movement"),
                        bullet("Supplements / Nutrition"),
                        bullet("Stress"),
                        bullet("Overall wellness choices"),

                        /// With AO Scan
                        mainHeading("With AO Scan, You Can"),

                        bullet(
                          "Run non-invasive, frequency-based scans almost anywhere where you have Wi-Fi (in-person or remotely)",
                        ),
                        bullet(
                          "Review educational reports on Body Systems, Vitals, Inner Voice, Comprehensive and stress patterns that may be moving the body away from homeostasis",
                        ),
                        bullet(
                          "Listen to customized Inner-Voice brain entrainment tones to help balance emotional frequencies",
                        ),
                        bullet(
                          "Listen to AO MindSync sessions (custom affirmations and guided audio for focus, intention, and daily mindset support)",
                        ),
                        bullet(
                          "Listen to, custom frequency broadcast with a specially tuned bone conduction headset, or imprint SEFI (subtle energetic frequency imprinter) frequency playlists into:",
                        ),

                        /// Nested Bullets
                        bullet("Mineral water"),
                        bullet("Sugar pellets"),
                        bullet("Gemstones"),
                        bullet("SEFIdots"),
                        bullet("Other carriers"),

                        bullet(
                          "Build and scan your own library of supplements, therapies, devices, and essential oils",
                        ),
                        bullet(
                          "Compare the resonance of those items against any body field profile",
                        ),
                        bullet(
                          "Track patterns over time to support your epigenetic and wellness decisions",
                        ),

                        /// Who Is It For
                        mainHeading("Who Is AO Scan For?"),
                        paragraph(
                          "AO Scan is designed for both professionals and everyday home users.",
                        ),
                        paragraph("Common users include:"),

                        bullet("Doctors and Chiropractors"),
                        bullet("Naturopaths and Holistic Practitioners"),
                        bullet("Health and Life Coaches"),
                        bullet("Energy and Biofeedback Practitioners"),
                        bullet("Personal Trainers and Fitness Professionals"),
                        bullet("Biohackers"),
                        bullet("Moms and Families"),
                        bullet(
                          "People supporting wellness routines for dogs, cats, and horses*",
                        ),

                        /// Why Love
                        mainHeading("Why People Love AO Scan"),
                        paragraph("People love AO Scan because it is:"),

                        bullet("Accessible"),
                        bullet("Non-invasive"),
                        bullet("Educational"),
                        bullet("Easy to use"),
                        bullet("Flexible for home or clinic use"),
                        bullet("Available in many supported countries"),

                        paragraph(
                          "Users can scan others (clients or patients) despite their physical location in the world by leveraging the quantum aspect of the technology.",
                        ),
                        paragraph(
                          "It is designed to support self-awareness and help people make more informed daily wellness choices while optimizing the body field with frequencies.",
                        ),

                        /// Subscription
                        mainHeading("One Subscription, Multiple Profiles"),
                        paragraph(
                          "One AO Scan subscription is not limited to just one person.",
                        ),
                        paragraph(
                          "You can create profiles and run scans for as many:",
                        ),

                        bullet("Patients"),
                        bullet("Clients"),
                        bullet("Friends"),
                        bullet("Family members"),

                        paragraph(
                          "as you choose, with access to the app and features available 24/7 while your subscription is active. You may also choose to share your login information with a colleague (within a clinic or a family member) so they can use the technology when you are not.",
                        ),

                        /// Get Started
                        mainHeading("Get Started"),
                        paragraph(
                          "Tap Get AO Scan below, and your subscription will be available immediately, so you can start scanning with confidence right away.",
                        ),
                        paragraph(
                          "You will be taken to the AO Scan subscription and product pricing page, along with details on training and community support from Solex Global and AO Scan Global — an Independent Quantum Living Advocate team and the largest independent AO Scan community worldwide.",
                        ),

                        /// BUTTON
                        SizedBox(
                          width: size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              final url = Uri.parse(
                                'https://shop.solexnation.com/energy1',
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Start AO Scan Now',
                              style: AppTextStyle.bold(
                                fontSize: 16,
                                color: AppColors.buttonTextWhite,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        mainHeading(
                          "If This Sounds Like You, You’re in the Right Place",
                        ),

                        paragraph("If you’re into things like:"),

                        bullet("Frequencies"),
                        bullet("Energy"),
                        bullet("Bioresonance"),
                        bullet("Biofeedback"),
                        bullet("Brain Entrainment"),
                        bullet("Affirmations"),
                        bullet("Mantras"),
                        bullet("Rife Frequencies"),
                        bullet("Solfeggio Tones"),
                        bullet("Tuning Forks"),
                        bullet("Scalar Frequencies"),
                        bullet("Body Optimization"),

                        paragraph("We are here for all of it!"),
                        paragraph("Join us today."),
                        paragraph(
                          "And if you haven’t yet received an AO Scan, we would love to give you a free demo as the largest AO Scan subscription reseller in the world.",
                        ),

                        paragraph(
                          "*Always consult your licensed healthcare provider or veterinarian with any medical questions or concerns.",
                        ),

                        const SizedBox(height: 20),

                        /// Signature
                        Text(
                          "Be Well & Do Good Things",
                          style: AppTextStyle.bold(fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Paige Mauer Wheeler",
                          style: AppTextStyle.regular(fontSize: 15),
                        ),
                        Text(
                          "AO Scan Global",
                          style: AppTextStyle.regular(fontSize: 15),
                        ),

                        const SizedBox(height: 30),

                        /// BUTTON
                        SizedBox(
                          width: size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              final url = Uri.parse(
                                'https://shop.solexnation.com/energy1',
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Start AO Scan Now',
                              style: AppTextStyle.bold(
                                fontSize: 16,
                                color: AppColors.buttonTextWhite,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 0),
                        const DisclaimerFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
