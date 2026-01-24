part of 'standings_cubit.dart';

class StandingsState {
  final bool isLoading;
  final String? error;
  final List<DriverLeaderBoardModel>? driverLeaderboard;
  final Map<String, List<DriverLeaderBoardModel>?> cache1;
  final List<ConstructorLeaderBoardModel>? constructorLeaderboard;
  final Map<String, List<ConstructorLeaderBoardModel>?> cache2;

  StandingsState({
    this.isLoading = false,
    this.error,
    this.driverLeaderboard,
    this.constructorLeaderboard,
    this.cache1 = const {},
    this.cache2 = const {},
  });

  bool isCached1(String year) {
    return cache1.containsKey(year);
  }

  bool isCached2(String year) {
    return cache2.containsKey(year);
  }

  static String getCacheKey1(String year) => year;
  static String getCacheKey2(String year) => year;

  StandingsState copyWith({
    bool? isLoading,
    String? error,
    List<DriverLeaderBoardModel>? driverLeaderboard,
    List<ConstructorLeaderBoardModel>? constructorLeaderboard,
    Map<String, List<DriverLeaderBoardModel>?>? cache1,
    Map<String, List<ConstructorLeaderBoardModel>?>? cache2,
  }) {
    return StandingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      driverLeaderboard: driverLeaderboard ?? this.driverLeaderboard,
      constructorLeaderboard:
          constructorLeaderboard ?? this.constructorLeaderboard,
      cache1: cache1 ?? this.cache1,
      cache2: cache2 ?? this.cache2,
    );
  }
}
