import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/presentation/auth/register/cubit/register_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Registration successful!"),
                backgroundColor: Colors.green,
              ),
            );
            context.go(RouteNames.home);
          } else if (state.status == RegisterStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? "Registration failed!"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
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
                              onChanged: (value) => context
                                  .read<RegisterCubit>()
                                  .updatePassword(value),
                              textCapitalization: TextCapitalization.words,
                              controller: _passController,
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
                              onChanged: (value) => context
                                  .read<RegisterCubit>()
                                  .updateCPassword(value),
                              controller: _cPassController,
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
                        onTap: () {
                          if (context.read<RegisterCubit>().state.password !=
                                  null &&
                              context
                                      .read<RegisterCubit>()
                                      .state
                                      .confirmPassword !=
                                  null &&
                              context.read<RegisterCubit>().state.password ==
                                  context
                                      .read<RegisterCubit>()
                                      .state
                                      .confirmPassword) {
                            context.read<RegisterCubit>().register();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Passwords do not match!"),
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
                  if (state.status == RegisterStatus.loading)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
