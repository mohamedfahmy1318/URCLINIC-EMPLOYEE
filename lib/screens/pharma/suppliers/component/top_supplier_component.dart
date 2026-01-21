import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/supplier_screen.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/view_all_label_component.dart';
import 'package:nb_utils/nb_utils.dart';

class TopSupplierComponent extends StatelessWidget {
  final List<Supplier> supplierList;

  const TopSupplierComponent({super.key, required this.supplierList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.value.topSupplier,
          isShowAll: true,
          onTap: () {
            Get.to(() => SupplierScreen());
          },
        ).paddingSymmetric(horizontal: 16),
        12.height,
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 16),
            itemCount: supplierList.length,
            separatorBuilder: (_, __) => 12.width,
            itemBuilder: (context, index) {
              final supplier = supplierList[index];

              return Container(
                width: supplierList.length > 1 ? 350 : Get.width - 32,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: boxDecorationDefault(
                  color: context.cardColor,
                  borderRadius: radius(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CachedImageWidget(
                      url: supplier.imageUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      circle: true,
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  supplier.supplierFullName ?? '-',
                                  style: boldTextStyle(size: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              12.width,
                              Icon(
                                supplier.status == 1 ? Icons.verified : Icons.info,
                                color: supplier.status == 1 ? Colors.green : Colors.grey,
                                size: 18,
                              ),
                            ],
                          ),
                          6.width,
                          Text(
                            "${supplier.unit} ${locale.value.unit}",
                            style: primaryTextStyle(color: appColorPrimary),
                          ),
                          6.height,
                          Text(
                            supplier.email,
                            style: secondaryTextStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).visible(supplierList.isNotEmpty);
  }
}
