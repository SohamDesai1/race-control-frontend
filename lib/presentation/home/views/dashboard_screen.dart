import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/views/widgets/carousel.dart';
import 'package:frontend/presentation/home/views/widgets/upcoming_card.dart';
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Carousel(),
            SizedBox(
              height: 3.h,
            ),
            Text("Upcoming Races",
                style: TextStyle(
                  fontSize: 4.w,
                )),
            SizedBox(
              height: 2.h,
            ),
            const UpcomingCard(),
            SizedBox(
              height: 2.h,
            ),
            const UpcomingCard(),
          ],
        ),
      ),
    ));
  }
}
