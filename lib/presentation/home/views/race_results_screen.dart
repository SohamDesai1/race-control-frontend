import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/views/widgets/driver_card.dart';
import 'package:sizer/sizer.dart';

class RaceResultsScreen extends StatefulWidget {
  final String raceName;
  final List raceResults;
  const RaceResultsScreen({
    super.key,
    required this.raceName,
    required this.raceResults,
  });

  @override
  State<RaceResultsScreen> createState() => _RaceResultsScreenState();
}

class _RaceResultsScreenState extends State<RaceResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.raceName,
          style: TextStyle(fontFamily: 'Formula1Bold', color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Race Results', style: TextStyle(fontSize: 5.w)),
          SizedBox(height: 2.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.raceName,
                style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: ListView.builder(
                  itemCount: widget.raceResults.length,
                  itemBuilder: (context, index) {
                    final recent = widget.raceResults[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: DriverCard(
                        driverName:
                            "${recent.driver.givenName} ${recent.driver.familyName}",
                        teamName: recent.constructor.name,
                        position: recent.position,
                        raceResult: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
