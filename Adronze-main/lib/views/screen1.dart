import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imager/imager.dart';

import '../main.dart';
import 'selectscreen.dart';

class screen1 extends StatefulWidget {
  const screen1({Key? key}) : super(key: key);

  @override
  State<screen1> createState() => _screen1State();
}

class _screen1State extends State<screen1> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(428, 954));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0xff29A9AB)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff29A9AB),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Imager.fromLocal("assets/images/screen1.png", height: 373.h, width: 256.w),
                  SizedBox(height: 50.h),
                  Text(
                    " Welcome to Adronze ",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp, color: Colors.white),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "Get your daily chores taken care of "
                          "at the push of a button while you "
                          "focus on your life.",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 100.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 30.w),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => selectscreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
                          decoration: BoxDecoration(
                            color: const Color(0xffFBFBFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Color(0xff2BCFD1)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
