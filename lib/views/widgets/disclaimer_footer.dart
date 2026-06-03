import 'package:flutter/material.dart';
import '../../utils/app_textstyle.dart';

class DisclaimerFooter extends StatelessWidget {
  const DisclaimerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            'AO Scan technology is an educational tool and not a medical device.AO Scan Global is the largest reseller of AO Scan technology. We are not Solex Global.I am an Independent Quantum Living Advocate for Solex Global.',
            style: AppTextStyle.regular(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffA7A7A7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
