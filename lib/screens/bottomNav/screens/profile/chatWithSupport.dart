import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/appDesignUtil.dart';

class ChatSupport extends StatefulWidget {
  String? name;
   ChatSupport({Key? key,required this.name})
       : super(key: key);

  @override
  State<ChatSupport> createState() => _ChatSupportState();
}

class _ChatSupportState extends State<ChatSupport> {
  var isVisible= false;
  var storeName ="";
  var storeEmail ="";

  @override
  void initState() {
    storeName=widget.name!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              child: Visibility(
                visible: isVisible,
                child: defaultDashboardAppBarWidget(() {
                  Get.back();
               },"Live chat",context: context),
              ),
              preferredSize: Size.fromHeight(60.h)),
        body: Container()
        // GestureDetector(
        //   onTap: (){
        //     setState(() {
        //       isVisible = !isVisible;
        //     });
        //   },
        //   child: Tawk(
        //     directChatLink: 'https://tawk.to/chat/646f6a06ad80445890ef16bd/1h19jcaj4',
        //     visitor: TawkVisitor(
        //       name: '$storeName',
        //       email: 'ayoubamine2a@gmail.com',
        //     ),
        //     onLoad: () {
        //       print('Hello Tawk!');
        //     },
        //     onLinkTap: (String url) {
        //       print(url);
        //     },
        //     placeholder: const Center(
        //       child: Text('Loading...'),
        //     ),
        //   ),
        // )
      ),
    );
  }
}
