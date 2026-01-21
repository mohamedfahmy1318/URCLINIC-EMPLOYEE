// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/price_widget.dart';
import '../../generate_invoice/components/add_billing_item_component.dart';
import '../invoice_details_controller.dart';

class BillingItemsWidget extends StatelessWidget {
  BillingItemsWidget({super.key});

  final InvoiceDetailsController genInvoiceCon = Get.find();

  @override
  Widget build(BuildContext context) {
    if (genInvoiceCon.billingItemList.isEmpty) {
      return const Offstage();
    }
    return Obx(
      () => AnimatedListView(
        shrinkWrap: true,
        itemCount: genInvoiceCon.billingItemList.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        listAnimationType: ListAnimationType.None,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: boxDecorationDefault(),
                  child: CachedImageWidget(
                    url: genInvoiceCon.billingItemList[index].serviceDetail != null ? genInvoiceCon.billingItemList[index].serviceDetail!.serviceImage : "",
                    fit: BoxFit.cover,
                    radius: 6,
                  ),
                ).paddingRight(16).visible(genInvoiceCon.billingItemList[index].serviceDetail != null),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          genInvoiceCon.billingItemList[index].itemName,
                          overflow: TextOverflow.ellipsis,
                          style: boldTextStyle(
                            size: 14,
                            weight: FontWeight.w600,
                            color: isDarkMode.value ? null : darkGrayTextColor,
                          ),
                        ).expand(),
                        Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                constraints: const BoxConstraints(),
                                style: const ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  genInvoiceCon.servicesCont.text = genInvoiceCon.billingItemList[index].itemName;
                                  genInvoiceCon.quantityCont.text = genInvoiceCon.billingItemList[index].quantity.toString();
                                  genInvoiceCon.priceCont.text = genInvoiceCon.billingItemList[index].totalAmount.toString();
                                  Get.bottomSheet(
                                    AddBillingItemComponent(
                                      billingItem: genInvoiceCon.billingItemList[index],
                                      index: index,
                                    ),
                                  );
                                },
                                icon: const CachedImageWidget(
                                  url: Assets.iconsIcEditReview,
                                  height: 18,
                                  width: 18,
                                  color: iconColor,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                                constraints: const BoxConstraints(),
                                style: const ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  genInvoiceCon.handleDeleteBillingItemClick(context: context, id: genInvoiceCon.billingItemList[index].id);
                                },
                                icon: const CachedImageWidget(
                                  url: Assets.iconsIcDelete,
                                  height: 18,
                                  width: 18,
                                  color: iconColor,
                                ),
                              ),
                            ],
                          ).visible(genInvoiceCon.isEditMode.value && !isAppointmentService(index)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.value.total,
                          overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(size: 12, color: dividerColor),
                        ),
                        16.width,
                        Flexible(
                          child: Marquee(
                            child: Row(
                              children: [
                                  if (genInvoiceCon.billingItemList[index].serviceAmount != genInvoiceCon.billingItemList[index].servicePriceWithDiscount)
                                    PriceWidget(
                                      price: genInvoiceCon.billingItemList[index].serviceAmountwithInclusiveTax,
                                      color: dividerColor,
                                      size: 12,
                                      isLineThroughEnabled: genInvoiceCon.billingItemList[index].serviceDetail != null && genInvoiceCon.billingItemList[index].serviceDetail!.discount ? true : false,
                                    ).paddingRight(6),
                                  PriceWidget(
                                    price: genInvoiceCon.billingItemList[index].servicePriceWithDiscount,
                                    color: dividerColor,
                                    size: 12,
                                  ),
                                  Text(" x ${genInvoiceCon.billingItemList[index].quantity} = ", style: primaryTextStyle(size: 12, color: dividerColor)),
                                PriceWidget(
                                  price: genInvoiceCon.billingItemList[index].totalAmount,
                                  color: appColorPrimary,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (genInvoiceCon.billingItemList[index].isIncludesInclusiveTaxAvailable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            " ${locale.value.includesInclusiveTax}",
                            style: secondaryTextStyle(
                              color: appColorSecondary,
                              size: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                  ],
                ).flexible(),
              ],
            ),
          );
        },
      ),
    );
  }

  bool isAppointmentService(int index) => genInvoiceCon.billingItemList[index].serviceDetail != null && genInvoiceCon.billingItemList[index].serviceDetail!.id == genInvoiceCon.invoiceData.value.serviceId;
}
