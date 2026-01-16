part of 'race_details_cubit.dart';

class RaceDetailsState {
  final bool isLoading;
  final String? error;
  final List<SessionModel>? raceDetails;
  final Map<String, List<SessionModel>?> cache1;
  final List<SessionDetailsModel>? sessionDetails;
  final Map<String, List<SessionDetailsModel>?> cache2;
  final List<DriverTelemetryModel>? driver1Telemetry;
  final List<DriverTelemetryModel>? driver2Telemetry;
  final List<DriverTelemetryModel>? driver3Telemetry;
  final Map<String, Map<String, List<DriverTelemetryModel>>?> cache3;
  final List<SectorTimingsModel>? sectorTimings;
  final Map<String, List<SectorTimingsModel>?> cache4;
  final QualiDetailsModel? qualiDetails;
  final Map<String, QualiDetailsModel?> cache5;
  final List<RacePaceComparisonModel>? racePaceComparison;
  final Map<String, List<RacePaceComparisonModel>?> cache6;
  final String? currentKey;

  RaceDetailsState({
    this.isLoading = false,
    this.error,
    this.raceDetails,
    this.cache1 = const {},
    this.currentKey,
    this.sessionDetails,
    this.cache2 = const {},
    this.driver1Telemetry,
    this.driver2Telemetry,
    this.driver3Telemetry,
    this.cache3 = const {},
    this.sectorTimings,
    this.cache4 = const {},
    this.qualiDetails,
    this.cache5 = const {},
    this.racePaceComparison,
    this.cache6 = const {},
  });

  bool isCached1(String year, String round) {
    return cache1.containsKey('$year-$round');
  }

  bool isCached2(String sessionId) {
    return cache2.containsKey(sessionId);
  }

  bool isCached3(String sessionId) {
    return cache3.containsKey(sessionId);
  }

  bool isCached4(String sessionId) {
    return cache4.containsKey(sessionId);
  }

  bool isCached5(String sessionId) {
    return cache5.containsKey(sessionId);
  }

  bool isCached6(String sessionId) {
    return cache6.containsKey(sessionId);
  }

  static String getCacheKey1(String year, String round) => '$year-$round';
  static String getCacheKey2(String sessionId) => sessionId;
  static String getCacheKey3(String sessionId) => sessionId;
  static String getCacheKey4(String sessionId) => sessionId;
  static String getCacheKey5(String sessionId) => sessionId;
  static String getCacheKey6(String sessionId) => sessionId;

  RaceDetailsState copyWith({
    bool? isLoading,
    String? error,
    List<SessionModel>? raceDetails,
    Map<String, List<SessionModel>?>? cache1,
    List<SessionDetailsModel>? sessionDetails,
    Map<String, List<SessionDetailsModel>?>? cache2,
    List<DriverTelemetryModel>? driver1Telemetry,
    List<DriverTelemetryModel>? driver2Telemetry,
    List<DriverTelemetryModel>? driver3Telemetry,
    Map<String, Map<String, List<DriverTelemetryModel>>>? cache3,
    List<SectorTimingsModel>? sectorTimings,
    Map<String, List<SectorTimingsModel>?>? cache4,
    QualiDetailsModel? qualiDetails,
    Map<String, QualiDetailsModel?>? cache5,
    List<RacePaceComparisonModel>? racePaceComparison,
    Map<String, List<RacePaceComparisonModel>?>? cache6,
    String? currentKey,
  }) {
    return RaceDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      raceDetails: raceDetails ?? this.raceDetails,
      cache1: cache1 ?? this.cache1,
      sessionDetails: sessionDetails ?? this.sessionDetails,
      cache2: cache2 ?? this.cache2,
      driver1Telemetry: driver1Telemetry ?? this.driver1Telemetry,
      driver2Telemetry: driver2Telemetry ?? this.driver2Telemetry,
      driver3Telemetry: driver3Telemetry ?? this.driver3Telemetry,
      cache3: cache3 ?? this.cache3,
      sectorTimings: sectorTimings ?? this.sectorTimings,
      cache4: cache4 ?? this.cache4,
      qualiDetails: qualiDetails ?? this.qualiDetails,
      cache5: cache5 ?? this.cache5,
      racePaceComparison: racePaceComparison ?? this.racePaceComparison,
      cache6: cache6 ?? this.cache6,
      currentKey: currentKey ?? this.currentKey,
    );
  }
}
