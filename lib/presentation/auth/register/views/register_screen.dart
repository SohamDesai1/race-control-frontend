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
      'Rocket',
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
  final TextEditingController _usernameController = TextEditingController(
    text: generateF1Username(),
  );
  final _formKey = GlobalKey<FormState>();
  bool _datePicked = false;

  void _pickDateDialog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
        _datePicked = true;
        context.read<RegisterCubit>().updateDob(
          DateFormat.yMMMd().format(_selectedDate),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().updateUsername(_usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                      fontFamily: 'Formula1Wide',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Full Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 70.w,
                    child: TextFormField(
                      onChanged: (value) =>
                          context.read<RegisterCubit>().updateName(value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.name,
                      decoration: _buildInputDecoration("Name"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text("Enter Email", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 70.w,
                    child: TextFormField(
                      onChanged: (value) =>
                          context.read<RegisterCubit>().updateEmail(value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      controller: _emailController,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration("Email"),
                      style: TextStyle(color: Colors.white, fontSize: 3.5.w),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text("Enter Username", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 70.w,
                    child: TextFormField(
                      onChanged: (value) {
                        context.read<RegisterCubit>().updateUsername(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                          return 'Username can only contain letters, numbers, and underscores';
                        }
                        return null;
                      },
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      decoration: _buildInputDecoration("Username"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Enter Date of Birth",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: _pickDateDialog,
                    child: Container(
                      width: 70.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: !_datePicked ? Colors.red : Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat.yMMMd().format(_selectedDate),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (!_datePicked)
                    Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: Text(
                        'Please select your date of birth',
                        style: TextStyle(color: Colors.red, fontSize: 10),
                      ),
                    ),
                  SizedBox(height: 6.h),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate() && _datePicked) {
                    context.pushNamed(RouteNames.setPassword);
                  } else if (!_datePicked) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select your date of birth"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(
                  height: 6.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFF50304),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                  ),
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
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white),
      errorStyle: TextStyle(color: Colors.redAccent),
      contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }
}
