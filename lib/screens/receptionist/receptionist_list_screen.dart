import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/receptionist/model/receptionist_res_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/receptionist/components/add_receptionist_component.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/receptionist_card_component.dart';
import 'receptionist_list_screen_controller.dart';

class ReceptionistListScreen extends StatelessWidget {
  ReceptionistListScreen({super.key});

  final ReceptionistsController receptionistsCont = Get.put(ReceptionistsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.receptionists,
      isLoading: receptionistsCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () async {
            Get.to(() => AddReceptionistComponent())?.then((value) {
              receptionistsCont.getReceptionist();
            });
          },
          icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
        ).paddingOnly(right: 8),
      ],
      body: Obx(
        () => SnapHelperWidget(
          future: receptionistsCont.getReceptionistList.value,
          loadingWidget: receptionistsCont.isLoading.value ? const Offstage() : const LoaderWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                receptionistsCont.page(1);
                receptionistsCont.getReceptionist();
              },
            ).visible(!receptionistsCont.isLoading.value);
          },
          onSuccess: (res) {
            return Obx(
              () => AnimatedListView(
                shrinkWrap: true,
                itemCount: receptionistsCont.receptionistList.length,
                padding: const EdgeInsets.all(24),
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                listAnimationType: ListAnimationType.None,
                emptyWidget: NoDataWidget(
                  title: locale.value.noReceptionistsFound,
                  subTitle: locale.value.oppsNoReceptionistsFoundAtMomentTryAgainLater,
                  imageWidget: const EmptyStateWidget(),
                ).paddingSymmetric(horizontal: 32).visible(!receptionistsCont.isLoading.value),
                onSwipeRefresh: () async {
                  receptionistsCont.page(1);
                  receptionistsCont.getReceptionist(showloader: false);
                  return Future.delayed(const Duration(seconds: 2));
                },
                onNextPage: () async {
                  if (!receptionistsCont.isLastPage.value) {
                    receptionistsCont.page++;
                    receptionistsCont.isLoading(true);
                    receptionistsCont.getReceptionist();
                  }
                },
                itemBuilder: (ctx, index) {
                  return ReceptionistCardComponent(
                    receptionist: receptionistsCont.receptionistList[index],
                    onEditClick: () {
                      Get.to(() => AddReceptionistComponent(isEdit: true), arguments: receptionistsCont.receptionistList[index])?.then((value) {
                        if (value == true) {
                          receptionistsCont.page(1);
                          receptionistsCont.getReceptionist();
                        }
                      });
                    },
                    onDeleteClick: () {
                      handleDeleteReceptionistClick(receptionistsCont.receptionistList, index, context);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> handleDeleteReceptionistClick(List<ReceptionistData> receptionist, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisReceptionist,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        receptionistsCont.isLoading(true);
        CoreServiceApis.deleteReceptionist(receptionistId: receptionist[index].receptionistId).then((value) {
          receptionist.removeAt(index);
          toast(value.message.trim().isEmpty ? locale.value.receptionistDeleteSuccessfully : value.message.trim());
          receptionistsCont.isLoading(false);
        }).catchError((e) {
          toast(e);
          receptionistsCont.isLoading(false);
        });
      },
    );
  }
}
