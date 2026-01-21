import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../model/doctor_list_res.dart';

class QualificationCard extends StatelessWidget {
  final int index;
  final Doctor doctorData;
  const QualificationCard({super.key, required this.index, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.year}:", style: secondaryTextStyle(size: 12)),
                  8.height,
                  Text(doctorData.qualifications[index].year, style: boldTextStyle(size: 12)),
                ],
              ).expand(),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.degree}:", style: secondaryTextStyle(size: 12)),
                  8.height,
                  Text(doctorData.qualifications[index].degree, style: boldTextStyle(size: 12)),
                ],
              ).expand(flex: 2),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.value.university}:", style: secondaryTextStyle(size: 12)),
                  8.height,
                  Text(doctorData.qualifications[index].university, style: boldTextStyle(size: 12)),
                ],
              ).expand(flex: 2),
              8.width,
            ],
          ).expand(),
        ],
      ),
    );
  }
}
