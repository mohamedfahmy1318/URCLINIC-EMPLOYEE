// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

class ToggleWidget extends StatefulWidget {
  bool isSwitched;
  double height;
  Function(bool)? onSiwtch;

  ToggleWidget({super.key, this.isSwitched = false, this.onSiwtch, this.height = 20});

  @override
  ToggleSwitchState createState() => ToggleSwitchState();
}

class ToggleSwitchState extends State<ToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: widget.height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: CupertinoSwitch(
          value: widget.isSwitched,
          onChanged: widget.onSiwtch,
          activeTrackColor: appColorPrimary,
        ),
      ),
    );
  }
}
