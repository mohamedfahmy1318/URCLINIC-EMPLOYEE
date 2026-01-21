import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import '../../../utils/colors.dart';
import '../utils/app_common.dart';

class DisplyFullScreenImgWidget extends StatelessWidget {
  final String imgUrl;
  final String? title;
  const DisplyFullScreenImgWidget({super.key, required this.imgUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hideAppBar: title == null,
      appBartitleText: title,
      appBarVerticalSize: Get.height * 0.12,
      body: Obx(
        () => Stack(
          children: [
            Center(
              child: SizedBox(
                width: Get.width,
                child: imgUrl.startsWith("http")
                    ? PhotoView(
                        backgroundDecoration: BoxDecoration(color: isDarkMode.value ? black : appScreenBackground),
                        imageProvider: NetworkImage(imgUrl),
                        // Replace this with your image path
                        initialScale: PhotoViewComputedScale.contained,
                        minScale: PhotoViewComputedScale.contained,
                        scaleStateChangedCallback: (value) {
                          log('scaleStateChangedCallback:$value ');
                        },

                        errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                        heroAttributes: PhotoViewHeroAttributes(tag: imgUrl),
                      )
                    : imgUrl.startsWith("assets/")
                        ? PhotoView(
                            backgroundDecoration: BoxDecoration(color: isDarkMode.value ? black : appScreenBackground),
                            imageProvider: AssetImage(imgUrl),
                            // Replace this with your image path
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained,
                            scaleStateChangedCallback: (value) {
                              log('scaleStateChangedCallback:$value ');
                            },

                            errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                            heroAttributes: PhotoViewHeroAttributes(tag: imgUrl),
                          )
                        : PhotoView(
                            backgroundDecoration: BoxDecoration(color: isDarkMode.value ? black : appScreenBackground),
                            imageProvider: FileImage(File(imgUrl)),
                            // Replace this with your image path
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained,
                            scaleStateChangedCallback: (value) {
                              log('scaleStateChangedCallback:$value ');
                            },

                            errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                            heroAttributes: PhotoViewHeroAttributes(tag: imgUrl),
                          ),
              ),
            ),
            Positioned(
              left: 16,
              top: 50,
              child: const Icon(Icons.arrow_back_ios).onTap(() async {
                Get.back();
              }),
            ).visible(title == null),
          ],
        ),
      ),
    );
  }
}
