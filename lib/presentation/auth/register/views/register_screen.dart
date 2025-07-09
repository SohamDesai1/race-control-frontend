import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/register/cubit/register_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

  late DateTime _selectedDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
        context
            .read<RegisterCubit>()
            .updateDob(DateFormat.yMMMd().format(_selectedDate));
      });
    });
  }

  static String demoUsername = generateF1Username();
  final TextEditingController _usernameController =
      TextEditingController(text: demoUsername);

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().updateUsername(demoUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
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
                    onChanged: (value) =>
                        context.read<RegisterCubit>().updateName(value),
                    textCapitalization: TextCapitalization.words,
                    controller: _nameController,
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
                    onChanged: (value) =>
                        context.read<RegisterCubit>().updateEmail(value),
                    controller: _emailController,
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
                    style: TextStyle(color: Colors.white, fontSize: 3.5.w),
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
                    onChanged: (value) {
                      context.read<RegisterCubit>().updateUsername(value);
                    },
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      // input text size
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
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
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  "Enter Date of Birth",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                    onTap: () {
                      _pickDateDialog();
                    },
                    child: Container(
                        width: 70.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat.yMMMd().format(_selectedDate),
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
                SizedBox(
                  height: 6.h,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (context.read<RegisterCubit>().state.name!.isEmpty ||
                    context.read<RegisterCubit>().state.email!.isEmpty ||
                    context.read<RegisterCubit>().state.username!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill all fields"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.push(RouteNames.setPassword);
              },
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
