import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../utils/notification_controller.dart';
import '../../appointment/appointment_detail.dart';
import '../../appointment/model/appointments_res_model.dart';
import '../model/notification_model.dart';
import 'notification_screen_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationScreenController notificationScreenController = Get.put(NotificationScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.notifications,
        appBarVerticalSize: Get.height * 0.12,
        isLoading: notificationScreenController.isLoading,
        actions: [
          GestureDetector(
            onTap: (){
              notificationScreenController.init(isReadAll: true);
              NotificationController.to.markAllRead();
            },
            child: Text(locale.value.readAll,style: secondaryTextStyle(color: Colors.white)),
          ).paddingOnly(right: 16)
        ],
        body: Obx(
          () => SnapHelperWidget(
            future: notificationScreenController.getNotificationList.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  notificationScreenController.page(1);
                  notificationScreenController.isLoading(true);
                  notificationScreenController.init();
                },
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: notificationScreenController.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (notifications) {
              return AnimatedListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                physics: const AlwaysScrollableScrollPhysics(),
                emptyWidget: NoDataWidget(
                  title: locale.value.stayTunedNoNew,
                  subTitle: locale.value.noNewNotificationsAt,
                  titleTextStyle: primaryTextStyle(),
                  imageWidget: const EmptyStateWidget(),
                  retryText: locale.value.reload,
                  onRetry: () {
                    notificationScreenController.page(1);
                    notificationScreenController.isLoading(true);
                    notificationScreenController.init();
                  },
                ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.1),
                itemBuilder: (context, index) {
                  final NotificationData notification = notificationScreenController.notificationDetail[index];
                  return GestureDetector(
                    onTap: () async {
                      final bool wasUnread = notification.readAt.trim().isEmpty;
                      if (wasUnread) {
                        final int? notifIntId = int.tryParse(notification.id);
                        if (notifIntId != null) {
                          unawaited(NotificationController.to.markAsRead(notifIntId));
                        }
                      }
                      if (notification.data.notificationDetail.id > 0 && notification.data.notificationDetail.appointmentId!= -1) {
                        await Get.to(
                          () => AppointmentDetail(),
                          arguments: AppointmentData(id: notification.data.notificationDetail.id, notificationId: notification.id),
                        );
                        notificationScreenController.page(1);
                        notificationScreenController.init();
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      decoration: notification.readAt.trim().isEmpty ? boxDecorationDefault(color: isDarkMode.value ? const Color.fromARGB(40, 78, 112, 247) : lightPrimaryColor) : boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          Row(
                            children: [
                              Container(
                                decoration: boxDecorationDefault(color: isDarkMode.value ? canvasColor : lightPrimaryColor, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: CachedImageWidget(
                                  url: Assets.assetsAppLogo,
                                  height: 20,
                                  width: 20,
                                  firstName: "#${notification.data.notificationDetail.id}",
                                  fit: BoxFit.cover,
                                  color: appColorPrimary,
                                  circle: true,
                                ),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.data.subject,style: primaryTextStyle(),),
                                  4.height,
                         /*         Text(
                                    getAppointmentNotification(notification: notification.data.notificationDetail.type),
                                    style: secondaryTextStyle(size: 14),
                                  ).visible(notification.data.notificationDetail.type.isNotEmpty),*/

                             /*     RichText(
                                    maxLines: 3,

                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                     //   TextSpan(text: '#${notification.data.notificationDetail.id}', style: primaryTextStyle(color: appColorSecondary, size: 12, decoration: TextDecoration.none)),
                              *//*          TextSpan(
                                            text:
                                                ' - ${notification.data.notificationDetail.notificationMsg.trim().isNotEmpty ? notification.data.notificationDetail.notificationMsg :notification
                                                    .data.notificationDetail.appointmentServicesNames.isNotEmpty? notification.data.notificationDetail.appointmentServicesNames:parseHtmlString(notification.data
                                                    .notificationDetail.message)}',
                                            style: primaryTextStyle(size: 12)),*//*
                                      ],
                                    ),
                                  ),*/
                                  Text( parseHtmlString(notification.data
                                      .notificationDetail.message)),
                                  4.height,
                                  Text(
                                    notification.createdAt.dateInyyyyMMddHHmmFormat.timeAgoWithLocalization,
                                    style: secondaryTextStyle(),
                                  ),
                                ],
                              ).flexible(),
                            ],
                          ),
                          16.height,
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ),
                  ).paddingBottom(16);
                },
                onNextPage: () async {
                  if (!notificationScreenController.isLastPage.value) {
                    notificationScreenController.page(notificationScreenController.page.value + 1);
                    notificationScreenController.isLoading(true);
                    notificationScreenController.init();
                    return Future.delayed(const Duration(seconds: 2), () {
                      notificationScreenController.isLoading(false);
                    });
                  }
                },
                onSwipeRefresh: () async {
                  notificationScreenController.page(1);
                  return notificationScreenController.init();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
