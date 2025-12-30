import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../repositories/session_repository.dart';
import '../../../models/race_details.dart';
part 'race_details_state.dart';

@injectable
class RaceDetailsCubit extends Cubit<RaceDetailsState> {
  RaceDetailsCubit(this.sessionRepository) : super(RaceDetailsState());

  final SessionRepository sessionRepository;

  Future<void> loadRaceDetails(String raceId, String year) async {
    final cacheKey = RaceDetailsState.getCacheKey(raceId, year);

    if (state.isCached(raceId, year)) {
      final cachedData = state.cache[cacheKey]!;
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

    final raceDetailsResult = await sessionRepository.getraceSessions(raceId, year);
    raceDetailsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (raceDetails) {
        final updatedCache = Map<String, List<SessionModel>?>.from(state.cache);
        updatedCache[cacheKey] = raceDetails!;

        emit(
          state.copyWith(
            isLoading: false,
            raceDetails: raceDetails,
            cache: updatedCache,
            currentKey: cacheKey,
            error: null,
          ),
        );
      },
    );
  }

  void clearCache(String year, String round) {
    final cacheKey = RaceDetailsState.getCacheKey(year, round);
    final updatedCache = Map<String, List<SessionModel>?>.from(state.cache);
    updatedCache.remove(cacheKey);
    emit(state.copyWith(cache: updatedCache));
  }

  void clearAllCache() {
    emit(state.copyWith(cache: {}, raceDetails: null, currentKey: null));
  }

  int get cacheSize => state.cache.length;
}
