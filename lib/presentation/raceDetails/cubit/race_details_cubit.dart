import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../repositories/race_repository.dart';
import '../../../models/race_details.dart';
part 'race_details_state.dart';

@injectable
class RaceDetailsCubit extends Cubit<RaceDetailsState> {
  RaceDetailsCubit(this.raceRepository) : super(RaceDetailsState());

  final RaceRepository raceRepository;

  Future<void> loadRaceDetails(String year, String round) async {
    final cacheKey = RaceDetailsState.getCacheKey(year, round);

    if (state.isCached(year, round)) {
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

    final raceDetailsResult = await raceRepository.getRaceDetails(year, round);
    raceDetailsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (raceDetails) {
        final updatedCache = Map<String, RaceDetailsModel>.from(state.cache);
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
    final updatedCache = Map<String, RaceDetailsModel>.from(state.cache);
    updatedCache.remove(cacheKey);
    emit(state.copyWith(cache: updatedCache));
  }

  void clearAllCache() {
    emit(state.copyWith(cache: {}, raceDetails: null, currentKey: null));
  }

  int get cacheSize => state.cache.length;
}
