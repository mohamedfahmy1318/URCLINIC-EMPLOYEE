import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/controller/pharma_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

// Replace with your actual model path

class PharmaDetailScreen extends StatelessWidget {
  final Pharma pharma;
  PharmaDetailScreen({super.key, required this.pharma});

  final PharmaController pharmaController = Get.put(PharmaController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: pharma.fullName,
      appBarVerticalSize: Get.height * 0.12,
      body: Stack(
        children: [
          /// Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Image Section ---
                CachedImageWidget(
                  url: pharma.imageUrl.validate(),
                  height: 180,
                  width: Get.width,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(defaultRadius),

                20.height,

                /// --- Name & Status ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        pharma.fullName.validate(),
                        style: boldTextStyle(size: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: pharma.status.getBoolInt() ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pharma.status.getBoolInt() ? "Active" : "Inactive",
                        style: secondaryTextStyle(
                          color: pharma.status.getBoolInt() ? Colors.green : Colors.red,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                10.height,

                /// --- Contact Info ---
                buildInfoTile(icon: Icons.email_outlined, label: 'Email', value: pharma.email),
                buildInfoTile(icon: Icons.phone_outlined, label: 'Phone', value: pharma.contactNumber),
                buildInfoTile(icon: Icons.location_on_outlined, label: 'Address', value: pharma.address),

                if (pharma.dateOfBirth.validate().isNotEmpty) buildInfoTile(icon: Icons.calendar_month_outlined, label: 'Date of Birth', value: pharma.dateOfBirth),

                if (pharma.gender.validate().isNotEmpty) buildInfoTile(icon: Icons.person_outline, label: 'Gender', value: pharma.gender),

                20.height,

                /// --- Clinic Info (if available) ---
                if (pharmaController.clinicData.value.name.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Clinic', style: boldTextStyle(size: 16)),
                      8.height,
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: boxDecorationDefault(color: context.cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pharmaController.clinicData.value.name.validate(),
                              style: primaryTextStyle(size: 14),
                            ),
                            if (pharmaController.clinicData.value.address.validate().isNotEmpty)
                              Text(
                                pharmaController.clinicData.value.address,
                                style: secondaryTextStyle(size: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                100.height, // space for bottom buttons
              ],
            ),
          ),

          /// --- Fixed Action Buttons ---
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                /// Call Button
                AppButton(
                  color: appColorPrimary,
                  onTap: () {
                    launchUrl(Uri.parse('tel:${pharma.contactNumber.validate()}'));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.call, color: white, size: 16),
                      6.width,
                      Text('Call', style: primaryTextStyle(color: white)),
                    ],
                  ),
                ).expand(),

                16.width,

                /// Email Button
                AppButton(
                  color: Colors.blueGrey,
                  onTap: () {
                    launchUrl(Uri.parse('mailto:${pharma.email.validate()}'));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.email, color: white, size: 16),
                      6.width,
                      Text('Email', style: primaryTextStyle(color: white)),
                    ],
                  ),
                ).expand(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper Widget for info items
  Widget buildInfoTile({required IconData icon, required String label, String? value}) {
    if (value.validate().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: secondaryTextColor, size: 18),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: secondaryTextStyle(size: 12)),
                4.height,
                Text(value!, style: primaryTextStyle(size: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
