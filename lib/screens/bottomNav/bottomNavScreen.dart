import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smerp_go/screens/bottomNav/screens/catalogue/catalogNew.dart';
import 'package:smerp_go/screens/bottomNav/screens/home.dart';
import 'package:smerp_go/screens/bottomNav/screens/inventory/inventory.dart';
import 'package:smerp_go/screens/bottomNav/screens/report/report.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../utils/appDesignUtil.dart';

class MainNavigationScreen extends StatefulWidget {
  int? position;
  MainNavigationScreen({this.position,Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  var currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  void initState() {
    if(widget.position!=null){
      onTap(widget.position!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: customText1('Exit App', kBlack, 18.sp),
              content: customText1(
                  'Do you want to exit the App?', kBlackB800, 16.sp),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    final screens = (widget.position!=null)?
    [
      const Home(),
      // const Wallet(),
      Inventory(tabPosition: 1,),
      const CatalogNew(),
     //const Catelogue(),
      const Report()
    ]:
    [
      const Home(),
      // const Wallet(),
       Inventory(),
      const CatalogNew(),
      //const Catelogue(),
      const Report()
    ];
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: Stack(
           fit: StackFit.passthrough,
          children: [
            screens[currentIndex],
            Align(
              alignment: Alignment(0.0,1.036),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                 child: SizedBox(
                   height: 98.h,
                   child: BottomNavigationBar(
                      selectedItemColor: kAppBlue,
                      unselectedItemColor: kBlackB600,
                      unselectedFontSize: 12.sp,
                      selectedFontSize: 12.sp,
                      unselectedLabelStyle: unselectedLabelStyle(),
                      selectedLabelStyle: selectedLabelStyle(),
                      type: BottomNavigationBarType.fixed,
                      currentIndex: currentIndex,
                      backgroundColor: kDashboardColorBorder,
                      onTap: (index) => setState(() => currentIndex = index),
                      items: [
                        BottomNavigationBarItem(
                          activeIcon: Image.asset(
                            'assets/homeActive.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          icon: Image.asset(
                            'assets/homeInactive.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Image.asset(
                            'assets/inventoryActive.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          icon: Image.asset(
                            'assets/inventoryInactive.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          label: 'Inventory',
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Image.asset(
                            'assets/catalogActive.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          icon: Image.asset(
                            'assets/catalogInactive.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          label: 'Catalogue',
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Image.asset(
                            'assets/chart.png',
                            width: 63.w,
                            height: 20.h,
                          ),
                          icon: Image.asset(
                            'assets/chart.png',
                            width: 63.w,
                            height: 20.h,
                            color: kBlackB600,
                          ),
                          label: 'Report',
                        ),
                      ],
                    ),
                 ),
                ),
              ),
            ),
          ],
        ),
       // bottomNavigationBar:

      ),
    );
  }

  EdgeInsets margin() => EdgeInsets.only(bottom: 8.9.h, top: 10.h);

  EdgeInsets margin2() => EdgeInsets.only(bottom: 7.9.h, top: 10.h);

  TextStyle unselectedLabelStyle() {
    return TextStyle(
        color: kBlackB600,
        fontFamily: 'inter regular',
        fontWeight: FontWeight.normal,
        fontSize: 14.sp);
  }

  TextStyle selectedLabelStyle() {
    return TextStyle(
        color: kBlackB600,
        fontFamily: 'inter regular',
        fontWeight: FontWeight.normal,
        fontSize: 16.sp);
  }
}
