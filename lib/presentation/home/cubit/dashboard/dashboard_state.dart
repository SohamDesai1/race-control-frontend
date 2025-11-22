part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final List<UpcomingRaceModel> races;

  DashboardSuccess(this.races);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
