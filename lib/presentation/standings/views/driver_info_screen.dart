import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/models/driver_leaderboard.dart';
import 'package:frontend/presentation/standings/views/cubit/standings_cubit.dart';
import 'package:frontend/utils/race_utils.dart';

class DriverInfoScreen extends StatefulWidget {
  final String driverName;
  final String constructorName;
  final String? season;

  const DriverInfoScreen({
    super.key,
    required this.driverName,
    required this.constructorName,
    this.season,
  });

  @override
  State<DriverInfoScreen> createState() => _DriverInfoScreenState();
}

class _DriverInfoScreenState extends State<DriverInfoScreen> {
  late String selectedYear;
  DriverLeaderBoardModel? driverData;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.season ?? DateTime.now().year.toString();
    _loadDriverData();
  }

  void _loadDriverData() async {
    await context.read<StandingsCubit>().loadStandingsData(
      int.parse(selectedYear),
    );
    final standingsState = context.read<StandingsCubit>().state;
    if (standingsState.driverLeaderboard != null) {
      final foundDriver = standingsState.driverLeaderboard!.where(
        (d) =>
            '${d.driver.givenName} ${d.driver.familyName}' == widget.driverName,
      );
      if (foundDriver.isNotEmpty) {
        driverData = foundDriver.first;
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final teamColor = RaceUtils.getF1TeamColor(
      widget.constructorName,
      year: int.parse(widget.season!),
    );
    final driverImage = RaceUtils.getDriverImage(widget.driverName);

    return Scaffold(
      backgroundColor: F1Theme.f1Black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 35.h,
            pinned: true,
            backgroundColor: F1Theme.f1Black,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: F1Theme.f1Black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: F1Theme.f1White),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          teamColor.withOpacity(0.8),
                          teamColor.withOpacity(0.3),
                          F1Theme.f1Black,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 7.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: teamColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: teamColor.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: driverImage != null
                                ? Image.asset(
                                    driverImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _buildPlaceholderDriver(teamColor),
                                  )
                                : _buildPlaceholderDriver(teamColor),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.driverName,
                              style: F1Theme.themeData.textTheme.displayMedium
                                  ?.copyWith(
                                    color: F1Theme.f1White,
                                    fontWeight: FontWeight.bold,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(F1Theme.mediumSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (driverData != null) ...[
                    _buildStatsSection(driverData!, teamColor),
                    SizedBox(height: 2.h),
                  ],
                  _buildDriverInfoSection(teamColor),
                  SizedBox(height: 2.h),
                  _buildConstructorSection(teamColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderDriver(Color teamColor) {
    return Container(
      color: F1Theme.f1DarkGray,
      child: Icon(Icons.person, size: 40, color: teamColor),
    );
  }

  Widget _buildStatsSection(DriverLeaderBoardModel driver, Color teamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Season Stats',
          style: F1Theme.themeData.textTheme.headlineMedium?.copyWith(
            color: F1Theme.f1White,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Position',
                driver.position,
                Icons.emoji_events,
                F1Theme.f1Red,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildStatCard(
                'Points',
                driver.points,
                Icons.star,
                Colors.amber,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildStatCard('Wins', driver.wins, Icons.flag, teamColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(F1Theme.mediumSpacing),
      decoration: BoxDecoration(
        gradient: F1Theme.cardGradient,
        borderRadius: F1Theme.mediumBorderRadius,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: F1Theme.themeData.textTheme.headlineMedium?.copyWith(
              color: F1Theme.f1White,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            label,
            style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
              color: F1Theme.f1TextGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoSection(Color teamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Driver Info',
          style: F1Theme.themeData.textTheme.headlineMedium?.copyWith(
            color: F1Theme.f1White,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(F1Theme.mediumSpacing),
          decoration: BoxDecoration(
            gradient: F1Theme.cardGradient,
            borderRadius: F1Theme.mediumBorderRadius,
            border: Border.all(color: F1Theme.f1LightGray.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                'Nationality',
                '${RaceUtils.getCountryFlag(driverData?.driver.nationality)} ${driverData?.driver.nationality ?? "N/A"}',
                Icons.flag,
              ),
              Divider(color: F1Theme.f1LightGray, height: 2.h),
              _buildInfoRow(
                'Date of Birth',
                driverData?.driver.dateOfBirth != null
                    ? '${driverData!.driver.dateOfBirth.day}/${driverData!.driver.dateOfBirth.month}/${driverData!.driver.dateOfBirth.year}'
                    : 'N/A',
                Icons.cake,
              ),
              Divider(color: F1Theme.f1LightGray, height: 2.h),
              _buildInfoRow(
                'Driver Abbreviation',
                driverData?.driver.code ?? 'N/A',
                Icons.badge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConstructorSection(Color teamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team',
          style: F1Theme.themeData.textTheme.headlineMedium?.copyWith(
            color: F1Theme.f1White,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () {
            context.push(
              RouteNames.constructorInfo,
              extra: {'constructorName': widget.constructorName},
            );
          },
          child: Container(
            padding: EdgeInsets.all(F1Theme.mediumSpacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  teamColor.withOpacity(0.3),
                  teamColor.withOpacity(0.1),
                ],
              ),
              borderRadius: F1Theme.mediumBorderRadius,
              border: Border.all(color: teamColor.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: F1Theme.f1DarkGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.directions_car, color: teamColor, size: 24),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.constructorName,
                        style: F1Theme.themeData.textTheme.titleLarge?.copyWith(
                          color: F1Theme.f1White,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tap to view team info',
                        style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
                          color: F1Theme.f1TextGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: teamColor, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Icon(icon, color: F1Theme.f1TextGray, size: 20),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              label,
              style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                color: F1Theme.f1TextGray,
              ),
            ),
          ),
          Text(
            value,
            style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
              color: F1Theme.f1White,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
