import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/components/home_bed_status_widget.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_detail_screen.dart';
import 'package:kivicare_clinic_admin/screens/dashboard/dashboard_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/home/choose_clinic_screen.dart';
import 'package:kivicare_clinic_admin/screens/home/components/doctor_analytics_component.dart';
import 'package:kivicare_clinic_admin/screens/home/components/receptionist_analytics_component.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../utils/local_storage.dart';
import '../auth/model/clinic_center_argument_model.dart';
import '../bed_management/bed_status_controller.dart';
import '../clinic/clinic_list_screen.dart';
import '../clinic/model/clinics_res_model.dart';
import '../service/all_service_list_screen.dart';
import 'components/appointment_home_component.dart';
import 'components/chart_component.dart';
import 'components/greetings_component.dart';
import 'components/clinic_admin_analytics_component.dart';
import 'components/home_component.dart';
import 'components/clinics_home_component.dart';
import 'components/service_home_component.dart';
import 'home_controller.dart';
import 'components/medicine_usage_chart_comp.dart';
import 'components/pharma_analytics_component.dart';
import 'components/today_prescriptions_home_component.dart';
import '../dashboard/components/menu.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/all_prescription_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/component/top_supplier_component.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<BedStatusController>(() => BedStatusController());
    return AppScaffoldNew(
      hasLeadingWidget: false,
      isBlurBackgroundinLoader: true,
      isLoading: homeScreenController.isLoading,
      appBarChild: const GreetingsComponent(),
      body: RefreshIndicator(
        onRefresh: () async {
          if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) {
          await getAppConfigurations();
            homeScreenController.getRevenueChartDetails(showLoader: false);
          }
          if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) {
            homeScreenController.getMedicineUsageChartData(showLoader: false);
          }
          return await homeScreenController.getDashboardDetail(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: homeScreenController.getDashboardDetailFuture.value,
            initialData: homeScreenController.dashboardData.value.status ? homeScreenController.dashboardData.value : null,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  homeScreenController.getDashboardDetail();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: homeScreenController.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (dashboardData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 90),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Container(
                        height: 52,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode.value ? context.cardColor : canvasColor.withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Row(
                          children: [
                            CachedImageWidget(
                              url: selectedAppClinic.value.clinicImage,
                              height: 32,
                              width: 32,
                              circle: true,
                              fit: BoxFit.cover,
                            ),
                            16.width,
                            Text(selectedAppClinic.value.name, overflow: TextOverflow.ellipsis, style: boldTextStyle(color: white, size: 14)).expand(),
                            TextButton(
                              style: const ButtonStyle().copyWith(
                                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Get.to(
                                  () => ChooseClinicScreen(),
                                  arguments: ClinicCenterArgumentModel(
                                    selectedClinc: selectedAppClinic.value,
                                  ),
                                )?.then((value) {
                                  if (value is ClinicData) {
                                    selectedAppClinic(value);
                                    loginUserData.value.selectedClinic = value;
                                    setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
                                    homeScreenController.getDashboardDetail();
                                  }
                                });
                              },
                              child: Text(locale.value.change, style: boldTextStyle(size: 12, fontFamily: fontFamilyWeight700, color: appColorSecondary)).paddingSymmetric(horizontal: 8),
                            ).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.doctor))
                          ],
                        ).onTap(() {
                          if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) {
                            Get.to(() => ClinicDetailScreen(), arguments: selectedAppClinic.value);
                          }
                        }),
                      ).paddingTop(16).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)),
                    ),
                    HomeComponent(
                      title: locale.value.analytics,
                      child: loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
                          ? ClinicAdminAnalyticComponent(homeScreenCont: homeScreenController)
                          : loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)
                              ? PharmaAnalyticComponent(homeScreenCont: homeScreenController)
                              : loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
                                  ? DoctorAnalyticComponent(homeScreenCont: homeScreenController)
                                  : ReceptionistAnalyticComponent(homeScreenCont: homeScreenController),
                    ),
                    if (homeScreenController.dashboardData.value.data.todayPrescription.isNotEmpty)
                      HomeComponent(
                        title: locale.value.newPrescription,
                        showSeeAll: true,
                        onSeeAllTap: () {
                          Get.to(() => AllPrescriptionsScreen());
                        },
                        child: TodaysPrescriptionHomeComponent(),
                      ),
                    HomeBedStatusWidget().visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)),
                    // End Bed Status Section
                    if (homeScreenController.dashboardData.value.data.clinics.isNotEmpty)
                      HomeComponent(
                        title: locale.value.clinics,
                        showSeeAll: true,
                        onSeeAllTap: () {
                          Get.to(() => ClinicListScreen());
                        },
                        child: ClinicsHomeComponent(),
                      ),
                    Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: boxDecorationDefault(),
                      child: Row(
                        children: [
                          const CachedImageWidget(
                            url: Assets.imagesEmptyBox,
                            height: 120,
                            width: 120,
                            circle: true,
                            fit: BoxFit.cover,
                          ),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.value.viewAndManageTheListOfServicesYouProvide, style: boldTextStyle(size: 14)),
                              16.height,
                              AppButton(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                                color: appColorSecondary,
                                onTap: () {
                                  Get.to(() => AllServicesScreen());
                                },
                                child: Text(locale.value.manageServices, style: boldTextStyle(size: 12, color: whiteTextColor, weight: FontWeight.w400)),
                              )
                            ],
                          ).expand(),
                        ],
                      ),
                    ).paddingTop(24).visible(homeScreenController.showAddServiceComp.value),
                    Obx(
                      () => HomeComponent(
                        title: locale.value.recentAppointment,
                        showSeeAll: true,
                        child: AppointmentsHomeComponent(),
                        onSeeAllTap: () {
                          final DashboardController dashboardController = Get.find();
                          dashboardController.selectedBottonNav(bottomNavItems[1]);
                          dashboardController.currentIndex(1);
                        },
                      ).visible(homeScreenController.dashboardData.value.data.upcomingAppointment.isNotEmpty),
                    ),

                    Obx(
                      () => HomeComponent(
                        title: locale.value.yourService,
                        showSeeAll: true,
                        onSeeAllTap: () {
                          Get.to(() => AllServicesScreen());
                        },
                        child: ServicesHomeComponent(),
                      ).visible(homeScreenController.dashboardData.value.data.doctorServices.isNotEmpty && loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)),
                    ),
                    Obx(() => homeScreenController.revenueData.value.data.yearChartData.isNotEmpty && loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)
                        ? ChartComponent()
                        : const Offstage()),
                    TopSupplierComponent(
                      supplierList: homeScreenController.dashboardData.value.data.topSuppliers,
                    ),
                    Obx(() => homeScreenController.medicineUsageChartData.value.data.isNotEmpty && loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) ? MedicineUsageChart(homeCont: homeScreenController) : Offstage())
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
