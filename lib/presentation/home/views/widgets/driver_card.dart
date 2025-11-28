import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DriverCard extends StatelessWidget {
  final bool raceResult;
  final String? driverName;
  final String? teamName;
  final String? position;
  final String? points;   
  const DriverCard({
    super.key,
    this.raceResult = false,
    this.driverName,
    this.teamName,
    this.position,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 5.w),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName ?? "L. Hamilton",
                  style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold),
                ),
                Text(
                  teamName ?? "Mercedes",
                  style: TextStyle(fontSize: 3.w, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        raceResult
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                width: 10.w,
                height: 3.h,
                child: Center(
                  child: Text(
                    "P$position" ?? "",
                    style: TextStyle(
                      fontSize: 4.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(left: 20.w),
                child: Text(
                  "$points pts",
                  style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold),
                ),
              ),
      ],
    );
  }
}
