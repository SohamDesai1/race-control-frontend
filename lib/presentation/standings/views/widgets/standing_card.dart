import 'package:flutter/material.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:sizer/sizer.dart';

class StandingCard extends StatelessWidget {
  final int position;
  final String driverName;
  final String? constructorName;
  final num? points;
  final Color highlightColor;
  final int index;
  final VoidCallback? onTap;
  const StandingCard({
    super.key,
    required this.position,
    required this.driverName,
    this.constructorName,
    this.points,
    this.highlightColor = const Color(0xFFFF8C00),
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: F1Theme.f1DarkGray,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              // Highlight color on left side (as a vertical strip)
              Container(
                width: 1.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    bottomLeft: Radius.circular(2),
                  ),
                ),
              ),

              SizedBox(width: 1.w),

              // Position in white container
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    position.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 4.w),

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  points?.toInt().toString() ?? "NA",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),

              // Arrow indicator
              Icon(Icons.arrow_forward_ios, color: F1Theme.f1White, size: 14),
              SizedBox(width: 2.w),
            ],
          ),
        ),
      ),
    );
  }
}
