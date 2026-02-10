import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/raceDetails/views/telemetry/driver_speed_widget.dart';
import 'package:frontend/presentation/raceDetails/views/telemetry/sector_timings_widget.dart';
import 'package:frontend/presentation/raceDetails/views/telemetry/race_pace_widget.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/widgets/f1_loading_indicator.dart';
import 'package:sizer/sizer.dart';

class TelemetryScreen extends StatefulWidget {
  final String sessionKey;
  final Map<String, String> drivers;
  final String season;
  final String sessionType;
  const TelemetryScreen({
    super.key,
    required this.sessionKey,
    required this.drivers,
    required this.season,
    required this.sessionType,
  });

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _loadedTabs = {};

  bool get _showRacePaceTab => widget.sessionType == "Race";
  int get _tabCount => _showRacePaceTab ? 3 : 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadTabData(_tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTabData(0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTabData(int index) {
    if (_loadedTabs.contains(index)) return;

    setState(() {
      _loadedTabs.add(index);
    });

    switch (index) {
      case 0:
        context.read<RaceDetailsCubit>().loadDriverTelemetryData(
          widget.sessionKey,
          widget.drivers.keys.toList(),
        );
        break;
      case 1:
        context.read<RaceDetailsCubit>().loadSectorTimingsData(
          widget.sessionKey,
        );
        break;
      case 2:
        if (_showRacePaceTab && widget.drivers.length >= 2) {
          context.read<RaceDetailsCubit>().loadRacePaceComparisonData(
            widget.sessionKey,
            widget.drivers.keys.elementAt(0),
            widget.drivers.keys.elementAt(1),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: F1Theme.f1Black,
        title: Text(
          "Telemetry Details",
          style: F1Theme.themeData.textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      F1Theme.f1Black.withOpacity(0.5),
                      F1Theme.f1Black.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: F1Theme.f1Red.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [F1Theme.f1Red, F1Theme.f1Red.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: F1Theme.f1Red.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: F1Theme.f1White,
                  unselectedLabelColor: F1Theme.f1White.withOpacity(0.5),
                  labelStyle: F1Theme.themeData.textTheme.headlineSmall
                      ?.copyWith(
                        fontFamily: 'Formula1Bold',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                  unselectedLabelStyle: F1Theme
                      .themeData
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontFamily: 'Formula1Regular',
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: [
                    Tab(text: 'Driver Speed', height: 4.h),
                    Tab(text: 'Sector Timing', height: 4.h),
                    if (_showRacePaceTab)
                      Tab(text: 'Race Pace', height: 4.h),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _loadedTabs.contains(0)
                        ? DriverSpeedWidget(
                            state: state,
                            drivers: widget.drivers,
                            season: widget.season,
                          )
                        : Center(
                            child: F1LoadingIndicator(
                              message: 'Loading speed trace...',
                              size: 60,
                            ),
                          ),
                    _loadedTabs.contains(1)
                        ? SectorTimingsWidget(
                            state: state,
                            drivers: widget.drivers,
                            season: widget.season,
                          )
                        : Center(
                            child: F1LoadingIndicator(
                              message: 'Loading sector times...',
                              size: 60,
                            ),
                          ),
                    if (_showRacePaceTab)
                      _loadedTabs.contains(2)
                          ? RacePaceWidgett(
                              state: state,
                              drivers: widget.drivers,
                              season: widget.season,
                              sessionType: widget.sessionType,
                            )
                          : Center(
                              child: F1LoadingIndicator(
                                message: 'Loading lap times...',
                                size: 60,
                              ),
                            ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
