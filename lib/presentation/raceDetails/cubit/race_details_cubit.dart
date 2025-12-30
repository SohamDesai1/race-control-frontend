import 'package:bloc/bloc.dart';
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

  void clearCache(String year, String round) {
    final cacheKey = RaceDetailsState.getCacheKey1(year, round);
    final updatedCache = Map<String, List<SessionModel>?>.from(state.cache1);
    updatedCache.remove(cacheKey);
    emit(state.copyWith(cache1: updatedCache));
  }

  void clearAllCache() {
    emit(state.copyWith(cache1: {}, raceDetails: null, currentKey: null));
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
}
