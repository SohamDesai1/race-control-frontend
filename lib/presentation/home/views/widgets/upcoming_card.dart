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
    return Container(
      height: 16.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 16, 16),
        border: Border.all(color: Colors.grey.shade900),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 1.w, top: 1.2.h, right: 1.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 7.h,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 35, 35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('dd MMM').format(date),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        raceName,
                        style: TextStyle(
                          fontSize: 3.7.w,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
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
                              style: TextStyle(
                                fontSize: 3.5.w,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                Container(
                  height: 3.5.h,
                  width: 22.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 35, 35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      RaceUtils.calcStatus(date),
                      style: TextStyle(
                        color: RaceUtils.calcColor(date),
                        fontSize: 2.7.w,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                SizedBox(width: 15.w),
                SizedBox(width: 3.w),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 5.5.h,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 30, 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
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
                SizedBox(width: 2.w),
                RaceUtils.calcStatus(date) != "Completed"
                    ? Expanded(
                        child: Container(
                          height: 5.5.h,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 35, 35, 35),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Set Reminder",
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
