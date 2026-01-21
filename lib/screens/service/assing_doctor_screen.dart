import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/service/components/search_service_doctor_widget.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../components/app_scaffold.dart';
import '../../components/bottom_selection_widget.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import 'assing_doctor_card.dart';
import 'assing_doctor_screen_controller.dart';
import 'components/service_clinic_list_widget.dart';

class AssingDoctorScreen extends StatelessWidget {
  AssingDoctorScreen({super.key});

  final AssingDoctorController assingDoctorCont = Get.put(AssingDoctorController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? locale.value.changePrice : locale.value.assignDoctor,
      isLoading: assingDoctorCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () {
            hideKeyboard(context);
            if (assingDoctorCont.selectClinic.value.id.isNegative) {
              toast(locale.value.pleaseSelectClinic);
            } else if (assingDoctorCont.selectServices.value.id.isNegative) {
              toast(locale.value.somethingWentWrong);
            } else {
              assingDoctorCont.saveDoctor();
            }
          },
          icon: const Icon(
            Icons.check_rounded,
            color: white,
          ),
        ).paddingRight(8),
      ],
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: assingDoctorCont.clinicCont,
              textFieldType: TextFieldType.NAME,
              readOnly: true,
              onTap: () async {
                if (assingDoctorCont.selectClinic.value.id.isNegative) {
                  assingDoctorCont.getClinicList();
                }
                serviceCommonBottomSheet(
                  context,
                  child: Obx(
                    () => BottomSelectionSheet(
                      title: locale.value.chooseClinic,
                      hintText: locale.value.searchForClinic,
                      hasError: assingDoctorCont.hasErrorFetchingClinic.value,
                      isEmpty: !assingDoctorCont.isClinicLoading.value && assingDoctorCont.clinicList.isEmpty,
                      errorText: assingDoctorCont.errorMessageClinic.value,
                      isLoading: assingDoctorCont.isClinicLoading,
                      searchApiCall: (p0) {
                        // Search specification processed
                        assingDoctorCont.searchClinic(p0);
                        assingDoctorCont.getClinicList();
                      },
                      onRetry: () {
                        assingDoctorCont.getClinicList();
                      },
                      listWidget: ServiceClinicListWidget(clinicList: assingDoctorCont.clinicList).expand(),
                    ),
                  ),
                );
              },
              decoration: inputDecoration(
                context,
                hintText: locale.value.selectClinic,
                fillColor: context.cardColor,
                filled: true,
                suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcHospital, color: iconColor, size: 10).paddingSymmetric(vertical: 16),
              ),
            ).paddingSymmetric(horizontal: 16).paddingTop(16).visible(assingDoctorCont.selectClinic.value.id.isNegative),
            SearchServiceDoctorWidget(
              doctorListCont: assingDoctorCont,
              onFieldSubmitted: (p0) {
                hideKeyboard(context);
              },
            ).paddingSymmetric(horizontal: 16).paddingTop(16).visible(assingDoctorCont.doctors.length > 6),
            if (!assingDoctorCont.selectClinic.value.id.isNegative)
              Expanded(
                child: SnapHelperWidget(
                  future: assingDoctorCont.doctorsFuture.value,
                  loadingWidget: assingDoctorCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        assingDoctorCont.page(1);
                        assingDoctorCont.getDoctors();
                      },
                    );
                  },
                  onSuccess: (res) {
                    return Obx(
                      () => AnimatedListView(
                        shrinkWrap: true,
                        itemCount: assingDoctorCont.doctors.length,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        emptyWidget: NoDataWidget(
                          title: locale.value.noDoctorsFound,
                          subTitle: locale.value.looksLikeThereAreNoDoctorsAvilableToAssign,
                          titleTextStyle: primaryTextStyle(),
                          imageWidget: const EmptyStateWidget(),
                        ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.1),
                        itemBuilder: (BuildContext context, int index) {
                          return AssingDoctorCardWid(
                            doctorData: assingDoctorCont.doctors[index],
                            assingDoctorCont: assingDoctorCont,
                            onTap: () {
                              hideKeyboard(context);
                            },
                          ).paddingBottom(16);
                        },
                        onSwipeRefresh: () async {
                          assingDoctorCont.page(1);
                          assingDoctorCont.getDoctors(showloader: false);
                        },
                        onNextPage: () async {
                          if (!assingDoctorCont.isLastPage.value) {
                            assingDoctorCont.page++;
                            assingDoctorCont.getDoctors();
                          }
                        },
                      ),
                    );
                  },
                ).paddingSymmetric(vertical: 16),
              ),
          ],
        ),
      ),
    );
  }
}
