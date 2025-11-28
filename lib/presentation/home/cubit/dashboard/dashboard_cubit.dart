import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../repositories/race_repository.dart';
import '../../../../models/recent_race.dart';
import '../../../../models/upcoming_race.dart';
import '../../../../models/driver_leaderboard.dart';
import 'package:meta/meta.dart';
part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.raceRepository) : super(DashboardInitial());

  final RaceRepository raceRepository;

  Future<void> fetchUpcomingRaces() async {
    emit(DashboardUpcomingLoading());
    final result = await raceRepository.getUpcomingRaces();
    result.fold((failure) {
      emit(DashboardError(failure.message));
    }, (races) => emit(DashboardUpcomingSuccess(races)));
  }

  Future<void> fetchRecentResults() async {
    emit(DashboardRecentLoading());
    final result = await raceRepository.getRecentResult();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (recent) => emit(DashboardRecentSuccess(recent!)),
    );
  }

  Future<void> fetchDriverLeaderboard() async {
    emit(DashboardDriverLeaderboardLoading());
    final result = await raceRepository.getDriverLeaderboard();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (leaderboard) => emit(DashboardDriverLeaderboardSuccess(leaderboard)),
    );
  }
}
