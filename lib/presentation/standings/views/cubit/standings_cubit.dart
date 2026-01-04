import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../repositories/race_repository.dart';
import '../../../../models/constructor_leaderboard.dart';
import '../../../../models/driver_leaderboard.dart';
part 'standings_state.dart';

@injectable
class StandingsCubit extends Cubit<StandingsState> {
  StandingsCubit(this.raceRepository) : super(StandingsState());

  final RaceRepository raceRepository;

  Future<void> loadStandingsData(int year) async {
    final cacheKey1 = StandingsState.getCacheKey1(year.toString());
    final cacheKey2 = StandingsState.getCacheKey2(year.toString());
    if (state.isCached1(year.toString()) && state.isCached2(year.toString())) {
      final cachedData1 = state.cache1[cacheKey1]!;
      final cachedData2 = state.cache2[cacheKey2]!;
      emit(
        state.copyWith(
          driverLeaderboard: cachedData1,
          constructorLeaderboard: cachedData2,
          isLoading: false,
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    var results = await Future.wait([
      raceRepository.getDriverLeaderboard(year, {}),
      raceRepository.getConstructorLeaderboard(year, {}),
    ]);

    results[0].fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (data) {
        final driverLeaderboardCache =
            Map<String, List<DriverLeaderBoardModel>?>.from(state.cache1);
        driverLeaderboardCache[cacheKey1] =
            data as List<DriverLeaderBoardModel>;
        emit(
          state.copyWith(
            isLoading: false,
            driverLeaderboard: data,
            cache1: driverLeaderboardCache,
            error: null,
          ),
        );
      },
    );
    results[1].fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (data) {
        final constructorLeaderboardCache =
            Map<String, List<ConstructorLeaderBoardModel>?>.from(state.cache2);
        constructorLeaderboardCache[cacheKey2] =
            data as List<ConstructorLeaderBoardModel>;
        emit(
          state.copyWith(
            isLoading: false,
            constructorLeaderboard: data,
            cache2: constructorLeaderboardCache,
            error: null
          ),
        );
      },
    );
  }
}
