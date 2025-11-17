import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({super.key});

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
            padding: EdgeInsets.only(left: 1.w, top: 1.2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 7.h,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 35, 35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text("09\nNov",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 4.w, fontWeight: FontWeight.w600))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sao Paulo Grand Prix",
                        style: TextStyle(
                            fontSize: 4.w, fontWeight: FontWeight.w600)),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 4.w, color: Colors.grey),
                        SizedBox(width: 1.w),
                        Text("Interlagos, Brazil",
                            style:
                                TextStyle(fontSize: 3.5.w, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 3.5.h,
                  width: 22.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 35, 35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text("Upcoming",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 2.7.w,
                              fontWeight: FontWeight.w600))),
                )
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 15.w,
              ),
              Container(
                height: 5.5.h,
                width: 34.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 30, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text("Race Details",
                        style: TextStyle(fontWeight: FontWeight.w600))),
              ),
              Container(
                height: 5.5.h,
                width: 34.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 35, 35, 35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text("Set Reminder",
                        style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
