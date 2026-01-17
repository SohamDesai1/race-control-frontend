import 'package:bloc/bloc.dart';
import 'package:frontend/models/driver_telemetry.dart';
import 'package:frontend/models/quali_details.dart';
import 'package:frontend/models/race_pace_comparison.dart';
import 'package:frontend/models/sector_timings.dart';
import 'package:frontend/models/session_details.dart';
import 'package:injectable/injectable.dart';
import '../../../repositories/session_repository.dart';
import '../../../models/race_details.dart';
part 'race_details_state.dart';

@injectable
class RaceDetailsCubit extends Cubit<RaceDetailsState> {
  RaceDetailsCubit(this.sessionRepository) : super(RaceDetailsState());

  final SessionRepository sessionRepository;

  Future<void> loadRaceDetails(String raceId, String year) async {
    final cacheKey = RaceDetailsState.getCacheKey1(raceId, year);

    if (state.isCached1(raceId, year)) {
      final cachedData = state.cache1[cacheKey]!;
      emit(
        state.copyWith(
          raceDetails: cachedData,
          currentKey: cacheKey,
          isLoadingRaceDetails: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingRaceDetails: true, error: null));

    final raceDetailsResult = await sessionRepository.getraceSessions(
      raceId,
      year,
    );
    raceDetailsResult.fold(
      (failure) {
        emit(
          state.copyWith(isLoadingRaceDetails: false, error: failure.message),
        );
      },
      (raceDetails) {
        try {
          final updatedCache = Map<String, List<SessionModel>?>.from(
            state.cache1,
          );
          updatedCache[cacheKey] = raceDetails!;

          emit(
            state.copyWith(
              isLoadingRaceDetails: false,
              raceDetails: raceDetails,
              cache1: updatedCache,
              currentKey: cacheKey,
              error: null,
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              isLoadingRaceDetails: false,
              error: 'Error processing race details: $e',
            ),
          );
        }
      },
    );
    raceDetailsResult.fold(
      (failure) {
        emit(
          state.copyWith(isLoadingRaceDetails: false, error: failure.message),
        );
      },
      (raceDetails) {
        final updatedCache = Map<String, List<SessionModel>?>.from(
          state.cache1,
        );
        updatedCache[cacheKey] = raceDetails!;

        emit(
          state.copyWith(
            isLoadingRaceDetails: false,
            raceDetails: raceDetails,
            cache1: updatedCache,
            currentKey: cacheKey,
            error: null,
          ),
        );
      },
    );
  }

  int get cacheSize => state.cache1.length;

  Future<void> loadSessionDetails(String sessionId) async {
    final cacheKey = RaceDetailsState.getCacheKey2(sessionId);

    if (state.isCached2(sessionId)) {
      final cachedData = state.cache2[cacheKey]!;
      emit(
        state.copyWith(
          sessionDetails: cachedData,
          currentKey: cacheKey,
          isLoadingSessionDetails: false,
          error: null,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoadingSessionDetails: true, error: null));

    final sessionDetailsResult = await sessionRepository.getSessionDetails(
      sessionId,
    );
    sessionDetailsResult.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingSessionDetails: false,
            error: failure.message,
          ),
        );
      },
      (sessionDetails) {
        final updatedCache = Map<String, List<SessionDetailsModel>?>.from(
          state.cache2,
        );
        updatedCache[cacheKey] = sessionDetails;
        emit(
          state.copyWith(
            isLoadingSessionDetails: false,
            sessionDetails: sessionDetails,
            currentKey: cacheKey,
            cache2: updatedCache,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> loadDriverTelemetryData(
    String sessionId,
    List<String> driverNumbers,
  ) async {
    if (driverNumbers.length != 3) {
      emit(
        state.copyWith(
          isLoadingDriverTelemetry: false,
          error: 'Expected 3 driver numbers, got ${driverNumbers.length}',
        ),
      );
      return;
    }

    final cacheKey = RaceDetailsState.getCacheKey3(sessionId);

    if (state.isCached3(sessionId)) {
      final cachedData = state.cache3[cacheKey]!;
      emit(
        state.copyWith(
          driver1Telemetry: cachedData['driver1'],
          driver2Telemetry: cachedData['driver2'],
          driver3Telemetry: cachedData['driver3'],
          currentKey: cacheKey,
          isLoadingDriverTelemetry: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingDriverTelemetry: true, error: null));

    try {
      print('🔄 Loading telemetry for drivers: ${driverNumbers.join(", ")}');

      final List<List<DriverTelemetryModel>?> driverDataList = [];

      // Fetch each driver sequentially with smart delay to avoid rate limiting
      for (int i = 0; i < driverNumbers.length; i++) {
        print('📡 [${i + 1}/3] Fetching driver ${driverNumbers[i]}...');

        final result = await sessionRepository.getDriverTelemetryData(
          sessionId,
          driverNumbers[i],
        );

        List<DriverTelemetryModel>? data;
        result.fold(
          (failure) =>
              print('❌ Driver ${driverNumbers[i]}: ${failure.message}'),
          (d) {
            try {
              // Additional validation to prevent backend format issues
              if (d != null && d.isNotEmpty) {
                data = d;
                print('✅ Driver ${driverNumbers[i]}: ${d.length} points');
              } else {
                print(
                  '⚠️  Driver ${driverNumbers[i]}: Invalid data format received',
                );
              }
            } catch (e) {
              print(
                '⚠️  Driver ${driverNumbers[i]}: Error processing data: $e',
              );
            }
          },
        );

        driverDataList.add(data);

        // Smart delay: shorter delay for first request, longer for subsequent ones
        // This helps balance between performance and avoiding rate limits
        if (i < driverNumbers.length - 1) {
          final delayMs = i == 0 ? 500 : 1000; // 500ms then 1000ms
          print('⏳ Waiting ${delayMs}ms before next request...');
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      }

      List<DriverTelemetryModel>? driver1Data = driverDataList[0];
      List<DriverTelemetryModel>? driver2Data = driverDataList[1];
      List<DriverTelemetryModel>? driver3Data = driverDataList[2];

      final int driversWithData = driverDataList
          .where((d) => d != null && d.isNotEmpty)
          .length;

      print('📊 Successfully loaded telemetry for $driversWithData/3 drivers');

      if (driver1Data != null || driver2Data != null || driver3Data != null) {
        final updatedCache =
            Map<String, Map<String, List<DriverTelemetryModel>>>.from(
              state.cache3,
            );
        updatedCache[cacheKey] = {
          'driver1': driver1Data ?? [],
          'driver2': driver2Data ?? [],
          'driver3': driver3Data ?? [],
        };

        emit(
          state.copyWith(
            isLoadingDriverTelemetry: false,
            driver1Telemetry: driver1Data,
            driver2Telemetry: driver2Data,
            driver3Telemetry: driver3Data,
            currentKey: cacheKey,
            cache3: updatedCache,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoadingDriverTelemetry: false,
            error:
                'No telemetry data available for any of the selected drivers',
          ),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print(stackTrace);
      emit(
        state.copyWith(
          isLoadingDriverTelemetry: false,
          error: 'Unexpected error: $e',
        ),
      );
    }
  }

  Future<void> loadSectorTimingsData(String sessionId) async {
    final cacheKey = RaceDetailsState.getCacheKey4(sessionId);

    if (state.isCached4(sessionId)) {
      final cachedData = state.cache4[cacheKey]!;
      emit(
        state.copyWith(
          sectorTimings: cachedData,
          currentKey: cacheKey,
          isLoadingSectorTimings: false,
          error: null,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoadingSectorTimings: true, error: null));

    final sectorTimingsResult = await sessionRepository.getSectorTimingsData(
      sessionId,
    );
    sectorTimingsResult.fold(
      (failure) {
        emit(
          state.copyWith(isLoadingSectorTimings: false, error: failure.message),
        );
      },
      (sectorTimings) {
        final updatedCache = Map<String, List<SectorTimingsModel>?>.from(
          state.cache4,
        );
        updatedCache[cacheKey] = sectorTimings;
        emit(
          state.copyWith(
            isLoadingSectorTimings: false,
            cache4: updatedCache,
            sectorTimings: sectorTimings,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> loadQualiSessionData(String year, String round) async {
    final cacheKey = RaceDetailsState.getCacheKey5(round);
    if (state.isCached5(round)) {
      final cachedData = state.cache5[cacheKey]!;
      emit(
        state.copyWith(
          qualiDetails: cachedData,
          currentKey: cacheKey,
          isLoadingQualiDetails: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingQualiDetails: true, error: null));
    final qualiSessionDataResult = await sessionRepository.getQualiDetails(
      year,
      round,
    );
    qualiSessionDataResult.fold(
      (failure) {
        emit(
          state.copyWith(isLoadingQualiDetails: false, error: failure.message),
        );
      },
      (qualiSession) {
        final updatedCache = Map<String, QualiDetailsModel?>.from(state.cache5);
        updatedCache[cacheKey] = qualiSession;
        emit(
          state.copyWith(
            isLoadingQualiDetails: false,
            cache5: updatedCache,
            qualiDetails: qualiSession,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> loadSprintQualiSessionData(String sessionId) async {
    final cacheKey = RaceDetailsState.getCacheKey5(sessionId);

    if (state.isCached5(sessionId)) {
      final cachedData = state.cache5[cacheKey]!;
      emit(
        state.copyWith(
          qualiDetails: cachedData,
          currentKey: cacheKey,
          isLoadingQualiDetails: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingQualiDetails: true, error: null));
    final sprintQualiSessionDataResult = await sessionRepository
        .getSprintQualiDetails(sessionId);
    sprintQualiSessionDataResult.fold(
      (failure) {
        emit(
          state.copyWith(isLoadingQualiDetails: false, error: failure.message),
        );
      },
      (sprintQualiSession) {
        final updatedCache = Map<String, QualiDetailsModel?>.from(state.cache5);
        updatedCache[cacheKey] = sprintQualiSession;
        emit(
          state.copyWith(
            isLoadingQualiDetails: false,
            cache5: updatedCache,
            qualiDetails: sprintQualiSession,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> loadRacePaceComparisonData(
    String sessionId,
    String driver1,
    String driver2,
  ) async {
    final cacheKey = RaceDetailsState.getCacheKey6(sessionId);

    if (state.isCached6(sessionId)) {
      final cachedData = state.cache6[cacheKey]!;
      emit(
        state.copyWith(
          racePaceComparison: cachedData,
          currentKey: cacheKey,
          isLoadingRacePaceComparison: false,
          error: null,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoadingRacePaceComparison: true, error: null));

    final sectorTimingsResult = await sessionRepository
        .getRacePaceComparisonData(
          sessionId,
          int.parse(driver1),
          int.parse(driver2),
        );
    sectorTimingsResult.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingRacePaceComparison: false,
            error: failure.message,
          ),
        );
      },
      (racePaceComparison) {
        final updatedCache = Map<String, List<RacePaceComparisonModel>?>.from(
          state.cache6,
        );
        updatedCache[cacheKey] = racePaceComparison;
        emit(
          state.copyWith(
            isLoadingRacePaceComparison: false,
            cache6: updatedCache,
            racePaceComparison: racePaceComparison,
            error: null,
          ),
        );
      },
    );
  }

  void clearAllCache() {
    emit(
      state.copyWith(
        cache1: {},
        cache2: {},
        cache3: {},
        cache4: {},
        cache5: {},
        cache6: {},
        currentKey: null,
      ),
    );
  }
}
