import 'package:flutter/material.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:sizer/sizer.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'What is Race Control?',
      'answer':
          'Race Control is a Formula 1 statistics and telemetry viewing application that provides real-time race data, standings, telemetry information, and race schedules.',
    },
    {
      'question': 'Where does the data come from?',
      'answer':
          'We use the OpenF1 API for real-time telemetry and timing data, and the Jolpica API for race schedules, standings, and results.',
    },
    {
      'question': 'Is the app free to use?',
      'answer': 'Yes, Race Control is currently free to download and use.',
    },
    {
      'question': 'How often is the data updated?',
      'answer':
          'Race data is updated in real-time during sessions. Historical data and standings are updated after each race.',
    },
    {
      'question': 'Can I view historical race data?',
      'answer':
          'Yes, you can view past race results and standings by selecting previous seasons from the calendar.',
    },
    {
      'question': 'What is telemetry data?',
      'answer':
          'Telemetry includes real-time data such as speed, throttle, brake, gear, and lap times for each driver during a session.',
    },
    {
      'question': 'Why is some data not available?',
      'answer':
          'Some data may be delayed or unavailable due to API restrictions, broadcasting rights, or technical issues.',
    },
    {
      'question': 'How do I report a bug?',
      'answer':
          'Please use the Send Feedback feature in Settings to report any bugs or issues you encounter.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Help Center',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(3.w),
        itemCount: _faqs.length,
        separatorBuilder: (_, __) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          return _FaqItem(
            question: _faqs[index]['question']!,
            answer: _faqs[index]['answer']!,
          );
        },
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: F1Theme.f1DarkGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          iconColor: F1Theme.f1TextGray,
          collapsedIconColor: F1Theme.f1TextGray,
          tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8),
          childrenPadding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
          title: Text(
            widget.question,
            style: TextStyle(
              fontFamily: 'Formula1Bold',
              fontSize: 14,
              color: F1Theme.f1White,
            ),
          ),
          children: [
            Text(
              widget.answer,
              style: TextStyle(
                fontFamily: 'Formula1Regular',
                fontSize: 13,
                color: F1Theme.f1TextGray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
