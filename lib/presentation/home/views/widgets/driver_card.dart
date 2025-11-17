import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DriverCard extends StatelessWidget {
  final bool raceResult;
  const DriverCard({super.key, this.raceResult = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 5.w,
            ),
            SizedBox(
              width: 4.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lando Norris",
                  style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "McLaren",
                  style: TextStyle(
                    fontSize: 3.w,
                    color: Colors.grey,
                  ),
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
                  "P1",
                  style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.bold,
                  ),
                )))
            : Container(
                margin: EdgeInsets.only(left: 20.w),
                child: Text(
                  "256 pts",
                  style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    );
  }
}
