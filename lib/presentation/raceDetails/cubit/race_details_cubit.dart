import 'package:bloc/bloc.dart';
import 'package:frontend/models/driver_telemetry.dart';
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
    List<String> driverNumbers, // Should have exactly 3 driver numbers
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

    // Check if cached
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

      // Make parallel API calls for all 3 drivers
      final results = await Future.wait([
        sessionRepository.getDriverTelemetryData(sessionId, driverNumbers[0]),
        sessionRepository.getDriverTelemetryData(sessionId, driverNumbers[1]),
        sessionRepository.getDriverTelemetryData(sessionId, driverNumbers[2]),
      ]);

      List<DriverTelemetryModel>? driver1Data;
      List<DriverTelemetryModel>? driver2Data;
      List<DriverTelemetryModel>? driver3Data;
      final List<String> errors = [];

      // Process driver 1
      results[0].fold(
        (failure) {
          print('❌ Driver ${driverNumbers[0]} failed: ${failure.message}');
          errors.add('Driver ${driverNumbers[0]}: ${failure.message}');
        },
        (data) {
          if (data != null && data.isNotEmpty) {
            driver1Data = data;
            print('✅ Driver ${driverNumbers[0]}: ${data.length} points');
          }
        },
      );

      // Process driver 2
      results[1].fold(
        (failure) {
          print('❌ Driver ${driverNumbers[1]} failed: ${failure.message}');
          errors.add('Driver ${driverNumbers[1]}: ${failure.message}');
        },
        (data) {
          if (data != null && data.isNotEmpty) {
            driver2Data = data;
            print('✅ Driver ${driverNumbers[1]}: ${data.length} points');
          }
        },
      );

      // Process driver 3
      results[2].fold(
        (failure) {
          print('❌ Driver ${driverNumbers[2]} failed: ${failure.message}');
          errors.add('Driver ${driverNumbers[2]}: ${failure.message}');
        },
        (data) {
          if (data != null && data.isNotEmpty) {
            driver3Data = data;
            print('✅ Driver ${driverNumbers[2]}: ${data.length} points');
          }
        },
      );

      // Check if at least one driver has data
      if (driver1Data != null || driver2Data != null || driver3Data != null) {
        // Update cache
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
            error: errors.isNotEmpty
                ? 'Partial load: ${errors.join("; ")}'
                : null,
          ),
        );
      } else {
        // All requests failed
        emit(
          state.copyWith(
            isLoading: false,
            error: 'All drivers failed: ${errors.join("; ")}',
          ),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print(stackTrace);
      emit(state.copyWith(isLoading: false, error: 'Unexpected error: $e'));
    }
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
