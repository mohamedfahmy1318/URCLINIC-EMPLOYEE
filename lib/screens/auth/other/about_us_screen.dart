import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.aboutApp,
      body: Column(
        children: [
          ListView.separated(
            itemCount: aboutPages.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (aboutPages[index].name.isEmpty || aboutPages[index].url.isEmpty) {
                return const SizedBox();
              } else {
                return SettingItemWidget(
                  title: aboutPages[index].name,
                  onTap: () {
                    commonLaunchUrl(aboutPages[index].url.trim(), launchMode: LaunchMode.externalApplication);
                  },
                  titleTextStyle: primaryTextStyle(),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                );
              }
            },
            separatorBuilder: (context, index) => commonDivider,
          ),
        ],
      ),
    );
  }
}
