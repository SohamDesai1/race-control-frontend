import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/route_names.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static String generateF1Username() {
    final prefixes = [
      'Turbo',
      'DRS',
      'PitStop',
      'Throttle',
      'Chicane',
      'OvertakeX',
      'F1Beast',
      'PoleSitter',
      'RaceCraft',
      'SlickTyres',
      'FastLap',
      'Rocket'
    ];
    final drivers = [
      'Max',
      'Lando',
      'Leclerc',
      'Hamilton',
      'Alonso',
      'Seb',
      'Kimi',
      'Gasly',
      'Piastri',
      'Russell',
      'Ricciardo',
      'Sainz',
      'Verstappen',
      'Norris',
      'Oscar',
      'Ocon',
      'Stroll',
      'Albon',
      'Zhou',
    ];
    final numbers = [7, 14, 22, 33, 44, 55, 63, 77, 81, 99];

    final rand = Random();
    final prefix = prefixes[rand.nextInt(prefixes.length)];
    final name = drivers[rand.nextInt(drivers.length)];
    final number = numbers[rand.nextInt(numbers.length)];

    return '$prefix$name$number';
  }

  final TextEditingController _usernameController =
      TextEditingController(text: generateF1Username());

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
                  "Enter Full Name",
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Name",
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
                  "Enter Email",
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
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
                  "Enter Username",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: 70.w,
                  child: TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Username",
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
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            GestureDetector(
              onTap: () => context.push(RouteNames.setPassword),
              child: Container(
                height: 6.h,
                width: 70.w,
                decoration: BoxDecoration(
                    color: Color(0xFFF50304),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white)),
                child: Center(
                  child: Text(
                    "Continue",
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
