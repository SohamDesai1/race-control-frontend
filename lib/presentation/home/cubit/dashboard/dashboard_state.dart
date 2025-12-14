part of 'dashboard_cubit.dart';

class DashboardState {
  final bool isLoading;
  final bool hasLoaded;
  final List<UpcomingRaceModel>? upcomingRaces;
  final RecentResultModel? recentResults;
  final List<DriverLeaderBoardModel>? driverLeaderboard;
  final List<ConstructorLeaderBoardModel>? constructorLeaderboard;
  final String? error;

  DashboardState({
    this.isLoading = false,
    this.hasLoaded = false,
    this.upcomingRaces,
    this.recentResults,
    this.driverLeaderboard,
    this.constructorLeaderboard,
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<UpcomingRaceModel>? upcomingRaces,
    RecentResultModel? recentResults,
    List<DriverLeaderBoardModel>? driverLeaderboard,
    List<ConstructorLeaderBoardModel>? constructorLeaderboard,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      upcomingRaces: upcomingRaces ?? this.upcomingRaces,
      recentResults: recentResults ?? this.recentResults,
      driverLeaderboard: driverLeaderboard ?? this.driverLeaderboard,
      constructorLeaderboard: constructorLeaderboard ?? this.constructorLeaderboard,
      error: error,
    );
  }
}

