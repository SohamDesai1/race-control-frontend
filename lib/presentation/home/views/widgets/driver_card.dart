import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/race_utils.dart';

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

  Color _getPositionColor(String? pos) {
    if (pos == null) return Colors.grey;
    final position = int.tryParse(pos) ?? 0;

    if (position == 1) return const Color(0xFFFFD700); // Gold
    if (position == 2) return const Color(0xFFC0C0C0); // Silver
    if (position == 3) return const Color(0xFFCD7F32); // Bronze
    if (position <= 10) return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final teamColor = RaceUtils.getF1TeamColor(teamName ?? '');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        border: Border(
          left: BorderSide(color: teamColor, width: 1.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: teamColor, width: 0.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: teamColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 6.w,
                    backgroundColor: Colors.grey[800],
                    backgroundImage:
                        RaceUtils.getDriverImage(driverName) != null
                        ? AssetImage(RaceUtils.getDriverImage(driverName)!)
                        : null,
                    child: RaceUtils.getDriverImage(driverName) == null
                        ? Icon(Icons.person, size: 6.w, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        driverName ?? "L. Hamilton",
                        style: TextStyle(
                          fontSize: 4.w,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Container(
                            width: 1.w,
                            height: 1.w,
                            decoration: BoxDecoration(
                              color: teamColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 1.5.w),
                          Flexible(
                            child: Text(
                              teamName ?? "Mercedes",
                              style: TextStyle(
                                fontSize: 3.w,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          raceResult
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getPositionColor(position),
                    borderRadius: BorderRadius.circular(2.w),
                    boxShadow: [
                      BoxShadow(
                        color: _getPositionColor(position).withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "P$position",
                    style: TextStyle(
                      fontSize: 4.w,
                      fontWeight: FontWeight.bold,
                      color:
                          (position != null &&
                              int.tryParse(position!) != null &&
                              int.parse(position!) <= 3)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: teamColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: teamColor.withOpacity(0.3),
                      width: 0.3.w,
                    ),
                  ),
                  child: Text(
                    "$points pts",
                    style: TextStyle(
                      fontSize: 3.5.w,
                      fontWeight: FontWeight.bold,
                      color: teamColor,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
