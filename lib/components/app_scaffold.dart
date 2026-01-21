import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/colors.dart';
import '../utils/common_base.dart';
import 'body_widget.dart';
import 'loader_widget.dart';

class AppScaffold extends StatelessWidget {
  final bool hideAppBar;

  //
  final Widget? leadingWidget;
  final Widget? appBarTitle;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final bool automaticallyImplyLeading;
  final double? appBarelevation;
  final String? appBartitleText;
  final Color? appBarbackgroundColor;

  //
  final Widget body;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;

  //
  final Widget? bottomNavBar;
  final Widget? fabWidget;
  final bool hasLeadingWidget;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomPadding;

  const AppScaffold({
    super.key,
    this.hideAppBar = false,
    //
    this.leadingWidget,
    this.appBarTitle,
    this.actions,
    this.appBarelevation = 0,
    this.appBartitleText,
    this.appBarbackgroundColor,
    this.isCenterTitle = false,
    this.hasLeadingWidget = true,
    this.automaticallyImplyLeading = false,
    //
    required this.body,
    this.isLoading,
    //
    this.bottomNavBar,
    this.fabWidget,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      appBar: hideAppBar
          ? null
          : PreferredSize(
              preferredSize: Size(Get.width, 66),
              child: AppBar(
                elevation: appBarelevation,
                automaticallyImplyLeading: automaticallyImplyLeading,
                backgroundColor: appBarbackgroundColor ?? context.scaffoldBackgroundColor,
                centerTitle: isCenterTitle,
                titleSpacing: 2,
                title: appBarTitle ??
                    Text(
                      appBartitleText ?? "",
                      style: primaryTextStyle(size: 16),
                    ).paddingLeft(hasLeadingWidget ? 0 : 16),
                actions: actions,
                leading: leadingWidget ?? (hasLeadingWidget ? backButton() : null),
              ).paddingTop(10),
            ),
      backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
      body: Body(
        isLoading: isLoading ?? false.obs,
        child: body,
      ),
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: fabWidget,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class AppScaffoldNew extends StatelessWidget {
  final Widget body;
  final Widget? appBarChild;
  final Widget? leadingWidget;
  final String? appBartitleText;
  final bool hasLeadingWidget;
  final List<Widget>? actions;
  final double? appBarVerticalSize;
  final Color? topBarBgColor;
  final bool? resizeToAvoidBottomPadding;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;
  final List<Widget> widgetsStackedOverBody;
  final bool hideAppBar;
  final bool isBlurBackgroundinLoader;
  final Clip clipBehaviorSplitRegion;
  final TextAlign titleAlign;

  const AppScaffoldNew({
    super.key,
    required this.body,
    this.appBarChild,
    this.leadingWidget,
    this.appBartitleText,
    this.hasLeadingWidget = true,
    this.actions,
    this.appBarVerticalSize,
    this.topBarBgColor,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
    this.isLoading,
    this.widgetsStackedOverBody = const [],
    this.hideAppBar = false,
    this.isBlurBackgroundinLoader = false,
    this.clipBehaviorSplitRegion = Clip.antiAlias,
    this.titleAlign = TextAlign.center,
  });

  double get topBarHeight => hideAppBar ? 0 : appBarVerticalSize ?? Get.height * 0.15;

  Widget get topBarComponent =>
      appBarChild ??
      SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appBartitleText ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: titleAlign,
                      style: primaryTextStyle(size: 18, fontFamily: GoogleFonts.interTight(fontWeight: FontWeight.w600).fontFamily, color: white),
                    ).expand(),
                  ],
                ).paddingSymmetric(horizontal: Get.width * 0.12),
                Positioned(
                  left: 0,
                  child: leadingWidget ??
                      (hasLeadingWidget
                          ? IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: white, size: 20),
                            )
                          : const Offstage()),
                ),
                Positioned(
                  right: 0,
                  child: Row(
                    children: actions ?? [],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(color: topBarBgColor ?? appColorPrimary),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  height: topBarHeight,
                  child: Container(
                    child: topBarComponent.paddingTop(context.statusBarHeight),
                  ),
                ),
                Container(
                  clipBehavior: clipBehaviorSplitRegion,
                  margin: EdgeInsets.only(top: topBarHeight),
                  decoration: boxDecorationDefault(
                    color: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(defaultRadius * 2),
                      topRight: Radius.circular(defaultRadius * 2),
                    ),
                  ),
                  child: SafeArea(top: false, child: body),
                ),
                SafeArea(
                  child: Stack(children: widgetsStackedOverBody),
                ),
              ],
            ),
          ),
          Obx(() => LoaderWidget(isBlurBackground: isBlurBackgroundinLoader).center().visible((isLoading ?? false.obs).value)),
        ],
      ),
    );
  }
}
