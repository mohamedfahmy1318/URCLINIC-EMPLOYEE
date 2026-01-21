import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../home_controller.dart';

class MedicineUsageChart extends StatelessWidget {
  MedicineUsageChart({super.key, required this.homeCont});

  final HomeController homeCont;

  /// This map will store the unique assigned colors for each medicine
  final Map<String, Color> _assignedColors = {};

  /// Generates a light color from hash and ensures no duplicates for current dataset
  Color _getUniqueLightColor(String name) {
    final key = name.toLowerCase();

    if (_assignedColors.containsKey(key)) {
      return _assignedColors[key]!;
    }

    Color newColor;
    int hashSeed = key.hashCode;
    do {
      final random = Random(hashSeed);
      int r = 180 + random.nextInt(76); // 180–255
      int g = 180 + random.nextInt(76);
      int b = 180 + random.nextInt(76);
      newColor = Color.fromARGB(255, r, g, b);

      hashSeed++; // change seed if collision
    } while (_assignedColors.containsValue(newColor));

    _assignedColors[key] = newColor;
    return newColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
      color: context.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(locale.value.medicineUsage, style: boldTextStyle(size: 18)).expand(),
              Obx(
                () => Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: boxDecorationDefault(color: isDarkMode.value ? lightCanvasColor : extraLightPrimaryColor, borderRadius: BorderRadius.circular(20)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: isDarkMode.value ? lightCanvasColor : extraLightPrimaryColor,
                      value: homeCont.medicineChartValue.value,
                      style: primaryTextStyle(size: 12),
                      items: homeCont.medicineUsageChartList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text("monthly", style: primaryTextStyle(size: 12)),
                      onChanged: (value) {
                        homeCont.medicineChartFilter(value: value.toString());
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: 10, left: 16, right: 16),
          // Text('Medicine Usage', style: boldTextStyle(size: 18)),
          16.height,
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              labelRotation: -45,
              labelIntersectAction: AxisLabelIntersectAction.none,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              numberFormat: NumberFormat.compact(),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            series: _buildStackedSeries(),
          ),
        ],
      ),
    );
  }

  List<StackedColumnSeries<_MedicineChartData, String>> _buildStackedSeries() {
    return homeCont.medicineUsageChartData.value.data.map((medicine) {
      final List<_MedicineChartData> chartData = List.generate(
        homeCont.medicineUsageChartData.value.categories.length,
        (i) => _MedicineChartData(homeCont.medicineUsageChartData.value.categories[i], medicine.data[i] as num),
      );

      return StackedColumnSeries<_MedicineChartData, String>(
        name: medicine.name,
        dataSource: chartData,
        xValueMapper: (_MedicineChartData data, _) => data.day,
        yValueMapper: (_MedicineChartData data, _) => data.value,
        borderRadius: BorderRadius.circular(6),
        color: _getUniqueLightColor(medicine.name),
      );
    }).toList();
  }
}

class _MedicineChartData {
  final String day;
  final num value;
  _MedicineChartData(this.day, this.value);
}
