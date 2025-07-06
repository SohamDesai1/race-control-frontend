import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.w,
                      fontFamily: 'Formula1Wide'),
                ),
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Password",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: 70.w,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: TextEditingController(),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Confirm Password",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: 70.w,
                  child: TextField(
                    controller: TextEditingController(),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            GestureDetector(
              child: Container(
                height: 6.h,
                width: 70.w,
                decoration: BoxDecoration(
                    color: Color(0xFFF50304),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white)),
                child: Center(
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
