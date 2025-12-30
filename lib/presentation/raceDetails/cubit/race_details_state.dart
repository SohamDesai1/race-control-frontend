part of 'race_details_cubit.dart';

class RaceDetailsState {
  final bool isLoading;
  final String? error;
  final List<SessionModel>? raceDetails;
  final Map<String, List<SessionModel>?> cache;
  final String? currentKey;

  RaceDetailsState({
    this.isLoading = false,
    this.error,
    this.raceDetails,
    this.cache = const {},
    this.currentKey,
  });

  bool isCached(String year, String round) {
    return cache.containsKey('$year-$round');
  }

  static String getCacheKey(String year, String round) => '$year-$round';

  RaceDetailsState copyWith({
    bool? isLoading,
    String? error,
    List<SessionModel>? raceDetails,
    Map<String, List<SessionModel>?>? cache,
    String? currentKey,
  }) {
    return RaceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      raceDetails: raceDetails ?? this.raceDetails,
      cache: cache ?? this.cache,
      currentKey: currentKey ?? this.currentKey,
    );
  }
}
