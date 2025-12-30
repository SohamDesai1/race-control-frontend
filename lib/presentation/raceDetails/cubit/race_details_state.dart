part of 'race_details_cubit.dart';

class RaceDetailsState {
  final bool isLoading;
  final String? error;
  final List<SessionModel>? raceDetails;
  final Map<String, List<SessionModel>?> cache1;
  final List<SessionDetailsModel>? sessionDetails;
  final Map<String, List<SessionDetailsModel>?> cache2;
  final String? currentKey;

  RaceDetailsState({
    this.isLoading = false,
    this.error,
    this.raceDetails,
    this.cache1 = const {},
    this.currentKey,
    this.sessionDetails,
    this.cache2 = const {},
  });

  bool isCached1(String year, String round) {
    return cache1.containsKey('$year-$round');
  }

  bool isCached2(String sessionId) {
    return cache2.containsKey(sessionId);
  }

  static String getCacheKey1(String year, String round) => '$year-$round';
  static String getCacheKey2(String sessionId) => sessionId;

  RaceDetailsState copyWith({
    bool? isLoading,
    String? error,
    List<SessionModel>? raceDetails,
    Map<String, List<SessionModel>?>? cache1,
    List<SessionDetailsModel>? sessionDetails,
    Map<String, List<SessionDetailsModel>?>? cache2,
    String? currentKey,
  }) {
    return RaceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      raceDetails: raceDetails ?? this.raceDetails,
      cache1: cache1 ?? this.cache1,
      sessionDetails: sessionDetails ?? this.sessionDetails,
      cache2: cache2 ?? this.cache2,
      currentKey: currentKey ?? this.currentKey,
    );
  }
}
