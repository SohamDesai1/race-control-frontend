import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DriverStandingCard extends StatelessWidget {
  final int position;
  final String driverName;
  final int points;
  final Color highlightColor;

  const DriverStandingCard({
    super.key,
    required this.position,
    required this.driverName,
    required this.points,
    this.highlightColor = const Color(0xFFFF8C00),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // ✅ Main Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ Position
                Text(
                  position.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                // ✅ Driver Name
                Expanded(
                  child: Center(
                    child: Text(
                      driverName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // ✅ Points
                Text(
                  points.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // ✅ ORANGE LINE BELOW THE CONTAINER (OUTSIDE)
          // const SizedBox(height: 4),
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
