part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

class DashboardUpcomingLoading extends DashboardState {}

class DashboardUpcomingSuccess extends DashboardState {
  final List<UpcomingRaceModel> upcomingRaces;
  DashboardUpcomingSuccess(this.upcomingRaces);
}

class DashboardRecentLoading extends DashboardState {}

class DashboardRecentSuccess extends DashboardState {
  final RecentResultModel recentResults;
  DashboardRecentSuccess(this.recentResults);
}
