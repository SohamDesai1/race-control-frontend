import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StandingCard extends StatelessWidget {
  final int position;
  final String driverName;
  final int points;
  final Color highlightColor;
  final int index;
  const StandingCard({
    super.key,
    required this.position,
    required this.driverName,
    required this.points,
    this.highlightColor = const Color(0xFFFF8C00),
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                // Position
                Text(
                  position.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(width: index < 9 ? 17.w : 14.w),

                // Driver name (START aligned)
                Expanded(
                  child: Text(
                    driverName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Points
                Text(
                  points.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 5,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
