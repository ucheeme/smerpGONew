import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appColors.dart';

class ToggleSwitch extends StatefulWidget {
//  final ValueChanged<bool> onToggle;
  bool value;

  ToggleSwitch({
    //required this.onToggle,
    // required this.initialValue,
    required this.value,
  });

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  // late bool _isToggled;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _isToggled = widget.initialValue;
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: widget.value ? kAppBlue : kInactiveLightPinkSwitch,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AnimatedAlign(
            duration: Duration(milliseconds: 200),
            alignment: widget.value ? Alignment.centerRight: Alignment.centerLeft,
            child: Container(
              width: 24.w,
              height: 49.h,
              margin: EdgeInsets.all(1.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.value ?  kLightPink: kInactiveLightPinkSwitchBu,
              ),
            ),
          ),
        ),
      ]

    );
  }
}