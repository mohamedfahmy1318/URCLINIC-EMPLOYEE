import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class LoaderWidget extends StatelessWidget {
  final bool isBlurBackground;
  final Color? loaderColor;

  const LoaderWidget({super.key, this.loaderColor, this.isBlurBackground = false});

  @override
  Widget build(BuildContext context) {
    return isBlurBackground
        ? AbsorbPointer(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0, tileMode: TileMode.mirror),
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: loaderColor ?? appColorSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        : SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: loaderColor ?? appColorSecondary,
                ),
              );
            },
          );
  }
}

class ThreeBounceLoadingWidget extends StatelessWidget {
  const ThreeBounceLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: 30,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColorPrimary,
          ),
        );
      },
    );
  }
}
