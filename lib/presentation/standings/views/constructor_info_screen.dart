import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/models/constructor_leaderboard.dart';
import 'package:frontend/models/driver_leaderboard.dart';
import 'package:frontend/presentation/standings/views/cubit/standings_cubit.dart';
import 'package:frontend/utils/race_utils.dart';

class ConstructorInfoScreen extends StatefulWidget {
  final String constructorName;
  final String? season;

  const ConstructorInfoScreen({
    super.key,
    required this.constructorName,
    this.season,
  });

  @override
  State<ConstructorInfoScreen> createState() => _ConstructorInfoScreenState();
}

class _ConstructorInfoScreenState extends State<ConstructorInfoScreen> {
  late String selectedYear;
  ConstructorLeaderBoardModel? constructorData;
  List<DriverLeaderBoardModel> teamDrivers = [];

  @override
  void initState() {
    super.initState();
    selectedYear = widget.season ?? DateTime.now().year.toString();
    _loadConstructorData();
  }

  void _loadConstructorData() {
    final standingsState = context.read<StandingsCubit>().state;

    if (standingsState.constructorLeaderboard != null) {
      final foundConstructor = standingsState.constructorLeaderboard!.where(
        (c) => c.constructor.name == widget.constructorName,
      );
      if (foundConstructor.isNotEmpty) {
        constructorData = foundConstructor.first;
      }
    }

    if (standingsState.driverLeaderboard != null) {
      teamDrivers = standingsState.driverLeaderboard!.where((d) {
        return d.constructors.any((c) => c.name == widget.constructorName);
      }).toList();
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final teamColor = RaceUtils.getF1TeamColor(widget.constructorName);
    final constructorLogo = RaceUtils.getConstructorLogo(
      widget.constructorName,
    );

    return Scaffold(
      backgroundColor: F1Theme.f1Black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 30.h,
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
                        colors: [teamColor.withOpacity(0.8), F1Theme.f1Black],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: F1Theme.f1DarkGray,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: teamColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: teamColor.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildConstructorLogo(
                              constructorLogo,
                              teamColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.constructorName,
                          style: F1Theme.themeData.textTheme.displayMedium
                              ?.copyWith(
                                color: F1Theme.f1White,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (constructorData != null)
                          Text(
                            constructorData!.constructor.nationality,
                            style: F1Theme.themeData.textTheme.bodyMedium
                                ?.copyWith(color: F1Theme.f1TextGray),
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
                  SizedBox(height: 2.h),
                  if (constructorData != null) ...[
                    _buildStatsSection(constructorData!, teamColor),
                    SizedBox(height: 2.h),
                  ],
                  _buildConstructorInfoSection(teamColor),
                  SizedBox(height: 2.h),
                  _buildTeamDriversSection(teamColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstructorLogo(String logoPath, Color teamColor) {
    return Image.asset(
      logoPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: F1Theme.f1DarkGray,
        child: Icon(Icons.directions_car, color: teamColor, size: 40),
      ),
    );
  }

  Widget _buildStatsSection(
    ConstructorLeaderBoardModel constructor,
    Color teamColor,
  ) {
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
                constructor.position,
                Icons.emoji_events,
                F1Theme.f1Red,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildStatCard(
                'Points',
                constructor.points,
                Icons.star,
                Colors.amber,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildStatCard(
                'Wins',
                constructor.wins,
                Icons.flag,
                teamColor,
              ),
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

  Widget _buildConstructorInfoSection(Color teamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Info',
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
                '${_getCountryFlag(constructorData?.constructor.nationality)} ${constructorData?.constructor.nationality ?? "N/A"}',
                Icons.flag,
              ),
              Divider(color: F1Theme.f1LightGray, height: 2.h),
              _buildInfoRow('Championships', '0', Icons.emoji_events),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamDriversSection(Color teamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Drivers',
          style: F1Theme.themeData.textTheme.headlineMedium?.copyWith(
            color: F1Theme.f1White,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        if (teamDrivers.isEmpty)
          Container(
            padding: EdgeInsets.all(F1Theme.mediumSpacing),
            decoration: BoxDecoration(
              gradient: F1Theme.cardGradient,
              borderRadius: F1Theme.mediumBorderRadius,
            ),
            child: Center(
              child: Text(
                'No drivers found for this team',
                style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
                  color: F1Theme.f1TextGray,
                ),
              ),
            ),
          )
        else
          ...teamDrivers.map(
            (driver) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: _buildDriverCard(driver, teamColor),
            ),
          ),
      ],
    );
  }

  Widget _buildDriverCard(DriverLeaderBoardModel driver, Color teamColor) {
    final driverName = '${driver.driver.givenName} ${driver.driver.familyName}';
    final driverImage = RaceUtils.getDriverImage(driverName);

    return GestureDetector(
      onTap: () {
        context.push(
          RouteNames.driverInfo,
          extra: {
            'driverName': driverName,
            'constructorName': widget.constructorName,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(F1Theme.mediumSpacing),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [teamColor.withOpacity(0.2), F1Theme.f1DarkGray],
          ),
          borderRadius: F1Theme.mediumBorderRadius,
          border: Border.all(color: teamColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: teamColor, width: 2),
              ),
              child: ClipOval(
                child: driverImage != null
                    ? Image.asset(
                        driverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.person, color: teamColor, size: 24),
                      )
                    : Icon(Icons.person, color: teamColor, size: 24),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: F1Theme.themeData.textTheme.titleLarge?.copyWith(
                      color: F1Theme.f1White,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'P${driver.position}',
                        style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
                          color: F1Theme.f1Red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${driver.points} pts',
                        style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
                          color: F1Theme.f1TextGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: teamColor, size: 16),
          ],
        ),
      ),
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
              style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
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

  String _getCountryFlag(String? nationality) {
    final Map<String, String> countryFlags = {
      'British': '🇬🇧',
      'Italian': '🇮🇹',
      'German': '🇩🇪',
      'French': '🇫🇷',
      'American': '🇺🇸',
      'Japanese': '🇯🇵',
      'Spanish': '🇪🇸',
      'Australian': '🇦🇺',
      'Finnish': '🇫🇮',
      'Dutch': '🇳🇱',
      'Mexican': '🇲🇽',
    };

    return countryFlags[nationality ?? ''] ?? '🏳️';
  }
}
