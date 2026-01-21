import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../home_controller.dart';
import '../model/revenue_chart_data.dart';

class ChartComponent extends StatelessWidget {
  ChartComponent({super.key});

  final HomeController homeCont = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
      color: context.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(locale.value.revenue, style: boldTextStyle(size: 18)),
              ),
              Flexible(
                child: Obx(
                  () => Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: boxDecorationDefault(
                      color: isDarkMode.value ? lightCanvasColor : extraLightPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: isDarkMode.value ? lightCanvasColor : extraLightPrimaryColor,
                        value: homeCont.revenueList.contains(homeCont.chartValue.value) ? homeCont.chartValue.value : null,
                        style: primaryTextStyle(size: 12),
                        items: homeCont.revenueList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        hint: Text(locale.value.yearly, style: primaryTextStyle(size: 12)),
                        onChanged: (value) {
                          if (value != null) {
                            homeCont.revenueFilter(value: value);
                          }
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: 10, left: 16, right: 16),
          Obx(
            () => SfCartesianChart(
              key: ValueKey(homeCont.chartValue.value),
              zoomPanBehavior: ZoomPanBehavior(
                enableDoubleTapZooming: true,
                enablePinching: true,
                enablePanning: true,
              ),
              enableAxisAnimation: true,
              legend: Legend(
                isVisible: true,
                isResponsive: true,
                position: LegendPosition.top,
                legendItemBuilder: (legendText, series, point, seriesIndex) {
                  return const Offstage();
                },
              ),
              title: ChartTitle(textStyle: secondaryTextStyle()),
              backgroundColor: context.cardColor,
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.compactCurrency(
                  symbol: "${appConfigs.value.currency.currencySymbol} ",
                  decimalDigits: 2,
                ),
              ),
              primaryXAxis: const CategoryAxis(
                labelPlacement: LabelPlacement.onTicks,
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0),
              ),
              crosshairBehavior: CrosshairBehavior(
                activationMode: ActivationMode.singleTap,
                lineType: CrosshairLineType.horizontal,
                enable: true,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                borderWidth: 1.5,
                color: context.cardColor,
                textStyle: secondaryTextStyle(color: isDarkMode.value ? null : darkGrayTextColor),
              ),
              series: <CartesianSeries>[
                SplineSeries<RevenueChartData, String>(
                  name: "",
                  dataSource: homeCont.chartData,
                  color: appColorPrimary,
                  legendIconType: LegendIconType.diamond,
                  splineType: SplineType.monotonic,
                  yValueMapper: (RevenueChartData sales, _) => sales.revenue,
                  xValueMapper: (RevenueChartData sales, _) => sales.month,
                ),
              ],
            ),
          ),
          8.height,
        ],
      ),
    );
  }
}
