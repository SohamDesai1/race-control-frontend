import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/constructor_leaderboard.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../../../repositories/race_repository.dart';
import '../../../../models/recent_race.dart';
import '../../../../models/upcoming_race.dart';
import '../../../../models/driver_leaderboard.dart';
part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.raceRepository) : super(DashboardState());

  final RaceRepository raceRepository;

  Future<void> loadDashboardData() async {
    // If already loaded, don’t call APIs again
    if (state.hasLoaded) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final upcoming = await raceRepository.getUpcomingRaces(
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final recent = await raceRepository.getRecentResult();
    final driverLeaderboard = await raceRepository.getDriverLeaderboard();
    final constructorLeaderboard = await raceRepository
        .getConstructorLeaderboard();

    upcoming.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (upcomingData) {
        recent.fold(
          (failure) =>
              emit(state.copyWith(isLoading: false, error: failure.message)),
          (recentData) {
            driverLeaderboard.fold(
              (failure) => emit(
                state.copyWith(isLoading: false, error: failure.message),
              ),
              (driverData) {
                constructorLeaderboard.fold(
                  (failure) => emit(
                    state.copyWith(isLoading: false, error: failure.message),
                  ),
                  (constructorData) {
                    emit(
                      state.copyWith(
                        isLoading: false,
                        hasLoaded: true,
                        upcomingRaces: upcomingData,
                        recentResults: recentData,
                        driverLeaderboard: driverData,
                        constructorLeaderboard: constructorData,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
