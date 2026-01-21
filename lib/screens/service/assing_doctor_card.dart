import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../components/cached_image_widget.dart';
import '../../components/decimal_input_formater.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../doctor/model/doctor_list_res.dart';
import 'all_service_list_controller.dart';
import 'assing_doctor_screen_controller.dart';

class AssingDoctorCardWid extends StatelessWidget {
  final Doctor doctorData;
  final void Function()? onTap;
  final AssingDoctorController assingDoctorCont;

  const AssingDoctorCardWid({
    super.key,
    this.onTap,
    required this.doctorData,
    required this.assingDoctorCont,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Row(
              children: [
                CachedImageWidget(
                  url: doctorData.profileImage,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  circle: true,
                ).paddingAll(16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(doctorData.fullName, style: boldTextStyle(size: 16)),
                        const Spacer(),
                        Obx(
                          () => Checkbox(
                            checkColor: whiteColor,
                            value: doctorData.isSelected.value,
                            activeColor: appColorPrimary,
                            visualDensity: VisualDensity.compact,
                            onChanged: (val) async {
                              doctorData.isSelected(val);
                              try {
                                final AllServicesController allSCont = Get.find();
                                for (final service in allSCont.serviceList) {
                                  for (final assignDoctor in service.assignDoctor) {
                                    if (assignDoctor.doctorId == doctorData.doctorId && assignDoctor.clinicId == assingDoctorCont.selectClinic.value.id && assignDoctor.serviceId == assingDoctorCont.selectServices.value.id) {
                                      doctorData.charges.text = assignDoctor.charges.toString();
                                    }
                                  }
                                }
                              } catch (e) {
                                log('allSCont = Get.find() Errr: $e');
                              }
                            },
                            side: const BorderSide(color: secondaryTextColor, width: 1.5),
                          ),
                        ),
                        8.width,
                      ],
                    ),
                    Text(doctorData.expert, style: secondaryTextStyle(size: 12)),
                    8.height,
                  ],
                ).expand(),
              ],
            ),
          ),
        ),
        Obx(
          () => AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: doctorData.charges,
            textFieldType: TextFieldType.NUMBER,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              DecimalTextInputFormatter(decimalRange: 2),
            ],
            decoration: inputDecoration(
              context,
              hintText: locale.value.charges,
              fillColor: context.cardColor,
              filled: true,
            ),
            suffix: commonLeadingWid(imgPath: Assets.iconsIcTotalPayout, color: secondaryTextColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ).paddingTop(8).visible(doctorData.isSelected.value),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
