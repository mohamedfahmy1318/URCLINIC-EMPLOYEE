import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../utils/colors.dart';
import '../../filter_controller.dart';

class FilterPaymentStatusComponent extends StatelessWidget {
  final FilterController filterCont;
  const FilterPaymentStatusComponent({super.key, required this.filterCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
              () =>
              AnimatedWrap(
                children: List.generate(
                  filterCont.paymentStatusList.length,
                      (index) {
                    final statusData = filterCont.paymentStatusList[index];
                    return InkWell(
                      onTap: () {
                        filterCont.paymentStatus(statusData['value']);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        margin: const EdgeInsets.all(4),
                        decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), color: filterCont.paymentStatus == statusData['value'] ? appColorPrimary : context.cardColor),
                        child: Text(
                          statusData['title'].toString(),
                          style: primaryTextStyle(
                            size: 12,
                            color: filterCont.paymentStatus == statusData['value'] ? white : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        ).paddingAll(16).expand(),
      ],
    );
  }
}
