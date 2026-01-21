import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/price_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../components/cached_image_widget.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';

class ProfilePicHorizotalWidget extends StatelessWidget {
  final double picSize;
  final String profileImage;
  final String heroTag;
  final String firstName;
  final String lastName;
  final String userName;
  final String subInfo;
  final num commission;
  final Function()? onCameraTap;
  final Function()? onPicTap;
  final bool showOnlyPhoto;
  final bool showCameraIconOnCornar;

  const ProfilePicHorizotalWidget({
    super.key,
    this.picSize = 70,
    required this.profileImage,
    required this.heroTag,
    this.firstName = "",
    this.lastName = "",
    required this.userName,
    this.subInfo = "",
    this.onCameraTap,
    this.onPicTap,
    this.commission = 0,
    this.showCameraIconOnCornar = true,
    this.showOnlyPhoto = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  16.width,
                  GestureDetector(
                    onTap: onPicTap,
                    child: SizedBox(
                      height: picSize + 16,
                      width: picSize + 16,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircularPercentIndicator(
                            radius: (picSize * 0.5) + 8,
                            lineWidth: 1.5,
                            percent: 1,
                            startAngle: 360 - 20,
                            progressColor: appColorSecondary,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: transparentColor,
                            center: Hero(
                              tag: heroTag,
                              child: CachedImageWidget(
                                url: profileImage,
                                firstName: firstName,
                                lastName: lastName,
                                height: picSize,
                                width: picSize,
                                fit: BoxFit.cover,
                                circle: true,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: -60,
                            left: 0,
                            child: Container(
                              height: 26,
                              alignment: Alignment.center,
                              child: AppButton(
                                height: 30,
                                width: 30,
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                elevation: 0,
                                shapeBorder: RoundedRectangleBorder(borderRadius: radius(100)),
                                color: appColorSecondary,
                                onTap: onCameraTap,
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                              ),
                            ).visible(!loginUserData.value.isSocialLogin),
                      ),
                        ],
                      ),
                    ),
                  ),
                  if (!showOnlyPhoto) ...[
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, style: boldTextStyle(size: 20)),
                        4.height,
                        Text(subInfo, style: primaryTextStyle(size: 14, color: secondaryTextColor)),
                      ],
                    ).expand(),
                  ],
                ],
              ),
            ],
          ),
          if(selectedAppCommission.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            decoration: boxDecorationDefault(color: isDarkMode.value ? context.cardColor : cardLightColor),
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: selectedAppCommission.length,
                itemBuilder: (context, index) {
              return Row(
                children: [
                  commonLeadingWid(imgPath: Assets.iconsIcUnFillWallet, color: appColorPrimary),
                  16.width,
                  Text(selectedAppCommission[index].name, style: primaryTextStyle(size: 14)),
                  const Spacer(),
                  if(selectedAppCommission[index].type == "percentage")
                    Text("${selectedAppCommission[index].value.toString()}%", style: primaryTextStyle(size: 14))
                  else
                  Text("${leftCurrencyFormat()}${selectedAppCommission[index].value.toString()}${rightCurrencyFormat()}", style: primaryTextStyle(size: 14)),
                //  Text(selectedAppCommission[index].type=="percentage" ? "%" : appConfigs.value.currency.currencySymbol, style: primaryTextStyle(size: 14,)),
                ],
              ) .paddingOnly(bottom: 16, left: 16, right: 16);

            }),
          ),
        ],
      ),
    );
  }
}
