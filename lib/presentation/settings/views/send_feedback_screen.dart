import 'package:email_sender/src/emailsender_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/presentation/settings/cubit/settings_cubit.dart';
import 'package:sizer/sizer.dart';

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({super.key});

  @override
  State<SendFeedbackScreen> createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Bug Report';

  final List<String> _categories = [
    'Bug Report',
    'Feature Request',
    'Data Issue',
    'App Suggestion',
    'Other',
  ];
  final EmailSender _emailSender = EmailSender();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Send Feedback',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          } else if (!state.isLoading && state.success == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Feedback submitted successfully!',
                  style: TextStyle(fontFamily: 'Formula1Regular'),
                ),
                backgroundColor: F1Theme.f1Red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(3.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'Formula1Bold',
                      fontSize: 14,
                      color: F1Theme.f1White,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    decoration: BoxDecoration(
                      color: F1Theme.f1MediumGray,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: F1Theme.f1LightGray),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        dropdownColor: F1Theme.f1DarkGray,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: F1Theme.f1TextGray,
                        ),
                        style: TextStyle(
                          fontFamily: 'Formula1Regular',
                          fontSize: 14,
                          color: F1Theme.f1White,
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Subject',
                    style: TextStyle(
                      fontFamily: 'Formula1Bold',
                      fontSize: 14,
                      color: F1Theme.f1White,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _subjectController,
                    style: TextStyle(color: F1Theme.f1White),
                    decoration: InputDecoration(
                      hintText: 'Brief description of your feedback',
                      hintStyle: TextStyle(color: F1Theme.f1TextGray),
                      filled: true,
                      fillColor: F1Theme.f1MediumGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: F1Theme.f1LightGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: F1Theme.f1LightGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: F1Theme.f1Red, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Message',
                    style: TextStyle(
                      fontFamily: 'Formula1Bold',
                      fontSize: 14,
                      color: F1Theme.f1White,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _messageController,
                    style: TextStyle(color: F1Theme.f1White),
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText:
                          'Describe your issue or suggestion in detail...',
                      hintStyle: TextStyle(color: F1Theme.f1TextGray),
                      filled: true,
                      fillColor: F1Theme.f1MediumGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: F1Theme.f1LightGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: F1Theme.f1LightGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: F1Theme.f1Red, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SettingsCubit>().sendFeedback(
                                  _emailSender,
                                  _subjectController.text,
                                  _messageController.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: F1Theme.f1Red,
                        foregroundColor: F1Theme.f1White,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'SUBMIT FEEDBACK',
                        style: TextStyle(
                          fontFamily: 'Formula1Bold',
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Text(
                      'We appreciate your feedback and will get back to you soon.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Formula1Regular',
                        fontSize: 12,
                        color: F1Theme.f1TextGray,
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
