import 'package:flutter/material.dart';
import 'package:frontend/presentation/standings/views/widgets/standing_card.dart';
import 'package:sizer/sizer.dart';

class StandingScreen extends StatefulWidget {
  const StandingScreen({super.key});

  @override
  State<StandingScreen> createState() => _StandingScreenState();
}

class _StandingScreenState extends State<StandingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // ✅ single controller

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // ✅ created once
  }

  @override
  void dispose() {
    _tabController.dispose(); // ✅ always dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Standings',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Drivers'),
              Tab(text: 'Constructors'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Color.fromARGB(255, 25, 18, 18),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 5.w),
                          Text(
                            'Pos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 18.w),
                          Text(
                            'Driver',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 40.w),
                          Text(
                            'Pts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.62,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return DriverStandingCard(
                              position: 1,
                              driverName: "Lando Norris",
                              points: 423,
                            );
                          },
                          itemCount: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    'Constructors Standings',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
