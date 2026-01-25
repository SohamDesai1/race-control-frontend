import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../cubit/race_details_cubit.dart';
import '../../standings/views/widgets/standing_card.dart';
import '../../../utils/race_utils.dart';
import '../../../core/constants/route_names.dart';
import '../../../core/theme/f1_theme.dart';
import '../../../core/widgets/f1_loading_indicator.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionName;
  final String sessionKey;
  final String season;
  const SessionDetailScreen({
    super.key,
    required this.sessionName,
    required this.sessionKey,
    required this.season,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;
  double _lastScrollPosition = 0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<RaceDetailsCubit>().loadSessionDetails(widget.sessionKey);
  }

  void _onScroll() {
    final currentPosition = _scrollController.position.pixels;
    if (currentPosition > _lastScrollPosition && currentPosition > 100) {
      // Scrolling down
      if (_showFab) {
        setState(() => _showFab = false);
      }
    } else if (currentPosition < _lastScrollPosition) {
      // Scrolling up
      if (!_showFab) {
        setState(() => _showFab = true);
      }
    }
    _lastScrollPosition = currentPosition;
  }

  Widget _buildHeaderCell(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: F1Theme.f1White, size: 4.w),
        SizedBox(width: F1Theme.smallSpacing),
        Text(
          text,
          style: F1Theme.themeData.textTheme.headlineSmall?.copyWith(
            color: F1Theme.f1White,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: F1Theme.f1Black,
        title: Text(
          "${widget.sessionName} Details",
          style: F1Theme.themeData.textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
        builder: (context, state) {
          if (state.isLoadingSessionDetails) {
            return Center(
              child: F1LoadingIndicator(message: 'Loading session details...'),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                  color: F1Theme.themeData.colorScheme.error,
                ),
              ),
            );
          }
          final sessionDetails = state.sessionDetails;
          if (sessionDetails == null) {
            return const Center(child: Text("No session details available."));
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(F1Theme.mediumSpacing),
            decoration: BoxDecoration(
              gradient: F1Theme.cardGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(F1Theme.xLargeSpacing),
                topRight: Radius.circular(F1Theme.xLargeSpacing),
              ),
              boxShadow: F1Theme.cardShadow,
            ),
            child: Column(
              children: [
                // Header with session info
                Container(
                  padding: EdgeInsets.all(F1Theme.mediumSpacing),
                  decoration: BoxDecoration(
                    gradient: F1Theme.redGradient,
                    borderRadius: F1Theme.mediumBorderRadius,
                    boxShadow: F1Theme.buttonShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderCell('Pos', Icons.flag),
                      _buildHeaderCell('Driver', Icons.person),
                      _buildHeaderCell('Pts', Icons.star),
                    ],
                  ),
                ),
                SizedBox(height: F1Theme.mediumSpacing),
                // Results list
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: F1Theme.f1DarkGray,
                      borderRadius: F1Theme.mediumBorderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: F1Theme.f1Black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final driver = sessionDetails[index];
                        final name = RaceUtils.mapDriverNameFromDriverNumber(
                          driver.driverNumber!,
                          int.parse(widget.season),
                        );
                        final color = RaceUtils.getF1TeamColor(name);
                        return StandingCard(
                          position: index + 1,
                          driverName: name,
                          points: driver.points,
                          highlightColor: color,
                          index: index,
                        );
                      },
                      itemCount: sessionDetails.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _showFab
          ? BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
              builder: (context, state) {
                final sessionDetails = state.sessionDetails;
                if (sessionDetails == null || state.isLoadingSessionDetails) {
                  return Container(); // Hide button when loading or no data
                }
                return FloatingActionButton.extended(
                  onPressed: () {
                    context.pushNamed(
                      RouteNames.telemetryDetails,
                      extra: {
                        "sessionKey": widget.sessionKey,
                        "drivers": {
                          for (var driver in sessionDetails.take(3))
                            driver.driverNumber!.toString():
                                RaceUtils.mapDriverNameFromDriverNumber(
                                  driver.driverNumber!,
                                  int.parse(widget.season),
                                ),
                        },
                        "season": widget.season,
                        "sessionType": widget.sessionName,
                      },
                    );
                  },
                  label: Row(
                    children: [
                      Icon(Icons.analytics, color: F1Theme.f1White, size: 4.w),
                      SizedBox(width: F1Theme.smallSpacing),
                      Text(
                        "View Telemetry",
                        style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
                          color: F1Theme.f1White,
                          fontFamily: "Formula1Bold",
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: F1Theme.f1Red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                );
              },
            )
          : null,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
