import 'package:ao_scan_app/utils/app_colors.dart';
import 'package:ao_scan_app/utils/app_textstyle.dart';
import 'package:ao_scan_app/views/screens/webview_screen.dart';
import 'package:ao_scan_app/views/widgets/disclaimer_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksScreen extends StatelessWidget {
  const SocialLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: mediaQuerySize.height,
          width: mediaQuerySize.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),

            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Contact & Resources",
                        style: AppTextStyle.bold().copyWith(fontSize: 18),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 14),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Connect with us and explore our educational materials",
                          ),
                        ),
                        SizedBox(height: 25),
                        _section("AO Scan Global Social", [
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.facebook.com/AOScanMobileAffiliate/",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/facebook_icon.svg",
                                height: 30,
                              ),
                              "Facebook",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.facebook.com/groups/330229588325135/",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/facebook_group.svg",
                                height: 30,
                              ),
                              "Facebook Group",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.instagram.com/aoscanglobal?igsh=a25rZXkzbnNlejgz&utm_source=qr",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/mdi_instagram.svg",
                                height: 30,
                              ),
                              "Instagram",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.youtube.com/@AOScanGlobal",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/mdi_youtube.svg",
                                height: 30,
                              ),
                              "Youtube",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl("https://x.com/ao_scan"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/ri_twitter-x-fill.svg",
                                height: 30,
                              ),
                              "X",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.linkedin.com/company/solex_ao_scan/?viewAsMember=true",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/pajamas_linkedin.svg",
                                height: 30,
                              ),
                              "LinkedIn",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.pinterest.com/aoscanglobal/",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/mdi_pinterest.svg",
                                height: 30,
                              ),
                              "Pinterest",
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                openUrl("https://substack.com/@aoscanglobal"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/mingcute_substack-fill.svg",
                                height: 30,
                              ),
                              "SubStack",
                            ),
                          ),
                        ]),
                        _section("AO Scan Global Contact", [
                          GestureDetector(
                            onTap: () =>
                                openUrl("https://wa.me/message/PEDHEKESXENHM1"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/ic_baseline-whatsapp.svg",
                                height: 30,
                              ),
                              "WhatsApp",
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri emailUri = Uri(
                                scheme: 'mailto',
                                path: 'info@aoscanglobal.com',
                              );

                              if (!await launchUrl(emailUri)) {
                                throw 'Could not open email app';
                              }
                            },
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/ic_outline-email.svg",
                                height: 30,
                              ),
                              "Email",
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                openUrl("http://www.aoscanglobal.com/contact"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/ix_user-profile-filled.svg",
                                height: 30,
                              ),
                              "Contact\nForm",
                            ),
                          ),
                        ]),
                        _section("Quantum Wellness Portal", [
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.quantumwellnessportal.com/landing",
                            ),
                            child: _item(
                              Icon(
                                Icons.menu_book,
                                size: 30,
                                color: const Color.fromARGB(243, 54, 76, 149),
                              ),
                              "Training Community",
                            ),
                          ),
                        ]),

                        _section("AO Scan Global Resources", [
                          GestureDetector(
                            onTap: () =>
                                openUrl("https://aoscanglobal.com/blog/"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/fe_document.svg",
                                height: 30,
                              ),
                              "Blogs",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl("https://aoscanglobal.com/"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/mdi_web.svg",
                                height: 30,
                              ),
                              "Website",
                            ),
                          ),
                        ]),

                        _section("Solex Global Social", [
                          GestureDetector(
                            onTap: () => openUrl(
                              "https://www.facebook.com/groups/266098628083609/",
                            ),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/facebook_group.svg",
                                height: 30,
                              ),
                              "Solex Global\nFacebook",
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                openUrl("https://www.youtube.com/@SolexLLC"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/mingcute_youtube-line.svg",
                                height: 30,
                              ),
                              "Solex LLC\nYouTube",
                            ),
                          ),
                        ]),
                        _section("Solex Global Education", [
                          GestureDetector(
                            onTap: () => openUrl("https://www.sharesolex.com/"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/solexDigital.svg",
                                height: 30,
                              ),
                              "Solex Digital\nMarketing Kit",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openUrl("https://susn.education/"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/solexschool.svg",
                                height: 30,
                              ),
                              "Solex University\nSchool of\nNaturopathy",
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                openUrl("https://www.solexuniversity.com/"),
                            child: _item(
                              SvgPicture.asset(
                                "assets/svgs/solexuniversity.svg",
                                height: 30,
                              ),
                              "Solex\nUniversity",
                            ),
                          ),
                        ]),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Divider(height: 0),
                        ),
                        DisclaimerFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F3C88),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => items[i],
          ),
        ],
      ),
    );
  }

  static Widget _item(Widget icon, String label) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.progressInactive),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: icon),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            flex: 2,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
