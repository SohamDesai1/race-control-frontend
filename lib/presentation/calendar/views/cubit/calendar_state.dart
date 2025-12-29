part of 'calendar_cubit.dart';

class CalendarState {
  final bool isLoading;
  final bool hasLoaded;
  final List<RaceModel>? calendarRaces;
  final String? error;
  final Map<String, List<RaceModel>> cache;
  final String? currentKey;

  CalendarState({
    this.isLoading = false,
    this.hasLoaded = false,
    this.calendarRaces,
    this.error,
    this.cache = const {},
    this.currentKey,
  });

  bool isCached(String year) {
    return cache.containsKey(year);
  }

  static String getCacheKey(String year) => year;

  CalendarState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<RaceModel>? calendarRaces,
    String? error,
    Map<String, List<RaceModel>>? cache,
    String? currentKey,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      calendarRaces: calendarRaces ?? this.calendarRaces,
      error: error,
      cache: cache ?? this.cache,
      currentKey: currentKey ?? this.currentKey,
    );
  }
}
