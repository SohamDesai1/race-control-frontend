// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class UpcomingCard extends StatelessWidget {
  final DateTime date;
  final String raceName;
  final String location;
  final VoidCallback? onTap;

  const UpcomingCard({
    super.key,
    required this.date,
    required this.raceName,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = RaceUtils.calcStatus(date) == "Completed";

    return Container(
      height: 16.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 16, 16),
        border: Border.all(color: Colors.grey.shade900),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DATE BOX
            Container(
              height: 14.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 35, 35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  DateFormat('dd MMM').format(date),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 6.1.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    raceName,
                    style: TextStyle(
                      fontSize: 4.2.w,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 4.w,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(fontSize: 4.w, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 30, 0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Race Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!isCompleted) ...[
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 35, 35, 35),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Set Reminder",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
