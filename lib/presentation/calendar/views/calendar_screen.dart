import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/presentation/calendar/views/cubit/calendar_cubit.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/home/views/widgets/upcoming_card.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String selectedYear = DateTime.now().year.toString();

  List<String> get availableYears {
    final currentYear = DateTime.now().year;
    final startYear = 2025;
    final endYear = currentYear + 1;

    return List.generate(
      endYear - startYear + 1,
      (index) => (startYear + index).toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().loadCalendarData(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Calendar',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            if (!state.hasLoaded) {
              return const SizedBox.shrink();
            }

            final calendar = state.calendarRaces;

            if (calendar!.isEmpty) {
              return const Center(child: Text("No upcoming races"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 35, 35, 35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedYear,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      underline: const SizedBox(),
                      dropdownColor: const Color.fromARGB(255, 35, 35, 35),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      items: availableYears.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (String? newYear) {
                        if (newYear != null && newYear != selectedYear) {
                          setState(() {
                            selectedYear = newYear;
                          });
                          context.read<CalendarCubit>().loadCalendarData(
                            newYear,
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.separated(
                    itemCount: calendar.length,
                    separatorBuilder: (_, __) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final race = calendar[index];
                      final raceDeets = context
                          .read<DashboardCubit>()
                          .state
                          .upcomingRaces![index];
                      return UpcomingCard(
                        date: race.date!,
                        raceName: race.raceName!,
                        location: "${raceDeets.locality}, ${raceDeets.country}",
                        onTap: () => context.pushNamed(
                          RouteNames.raceDetails,
                          extra: {
                            'season': race.season,
                            'raceId': race.id.toString(),
                            'gpName': race.raceName,
                            'trackimage': RaceUtils.mapTrackImage(
                              race.circuitId!,
                            ),
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
