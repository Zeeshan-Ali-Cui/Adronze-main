import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imager/imager.dart';

import '../main.dart';
import 'Signup.dart';

class selectscreen extends StatefulWidget {
  const selectscreen({Key? key}) : super(key: key);

  @override
  State<selectscreen> createState() => _selectscreenState();
}

class _selectscreenState extends State<selectscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff29A9AB),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.1.sh, horizontal: 0.05.sw), // Adjusted padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Imager.fromLocal("assets/images/screen2.png", height: 0.45.sh, width: 0.3.sw),
              SizedBox(height: 0.05.sh),
              Text(
                " Welcome to Adronze ",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.sp, color: Colors.white),
              ),
              SizedBox(height: 0.02.sh),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                child: Text(
                  "Get your daily chores taken care of "
                      "at the push of a button while you "
                      "focus on your life.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 0.1.sh), // Adjusted spacing
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signup()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 0.25.sw),
                  decoration: BoxDecoration(
                    color: const Color(0xffFBFBFB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    " Create an Account ",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2BCFD1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 0.05.sh),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4F4F4F),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondScreen()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.1.sh), // Adjusted spacing
            ],
          ),
        ),
      ),
    );
  }
}
