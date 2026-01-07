import 'package:bloc/bloc.dart';
import 'package:frontend/models/driver_telemetry.dart';
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
          isLoading: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final raceDetailsResult = await sessionRepository.getraceSessions(
      raceId,
      year,
    );
    raceDetailsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (raceDetails) {
        final updatedCache = Map<String, List<SessionModel>?>.from(
          state.cache1,
        );
        updatedCache[cacheKey] = raceDetails!;

        emit(
          state.copyWith(
            isLoading: false,
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
          isLoading: false,
          error: null,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));

    final sessionDetailsResult = await sessionRepository.getSessionDetails(
      sessionId,
    );
    sessionDetailsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (sessionDetails) {
        final updatedCache = Map<String, List<SessionDetailsModel>?>.from(
          state.cache2,
        );
        updatedCache[cacheKey] = sessionDetails;
        emit(
          state.copyWith(
            isLoading: false,
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
          isLoading: false,
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
          isLoading: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      print('🔄 Loading telemetry for drivers: ${driverNumbers.join(", ")}');

      final List<List<DriverTelemetryModel>?> driverDataList = [];

      // Fetch each driver sequentially with delay
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
            if (d != null && d.isNotEmpty) {
              data = d;
              print('✅ Driver ${driverNumbers[i]}: ${d.length} points');
            }
          },
        );

        driverDataList.add(data);

        // Wait 500ms before next request (but not after the last one)
        if (i < driverNumbers.length - 1) {
          print('⏳ Waiting 1000ms before next request...');
          await Future.delayed(const Duration(milliseconds: 1000));
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
            isLoading: false,
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
            isLoading: false,
            error:
                'No telemetry data available for any of the selected drivers',
          ),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print(stackTrace);
      emit(state.copyWith(isLoading: false, error: 'Unexpected error: $e'));
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
          isLoading: false,
          error: null,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));

    final sectorTimingsResult = await sessionRepository.getSectorTimingsData(
      sessionId,
    );
    sectorTimingsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (sectorTimings) {
        final updatedCache = Map<String, List<SectorTimingsModel>?>.from(
          state.cache4,
        );
        updatedCache[cacheKey] = sectorTimings;
        emit(
          state.copyWith(
            isLoading: false,
            cache4: updatedCache,
            sectorTimings: sectorTimings,
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
        raceDetails: null,
        currentKey: null,
      ),
    );
  }
}
