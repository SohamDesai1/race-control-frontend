import 'package:flutter_bloc/flutter_bloc.dart';
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
    // If already loaded, don't call APIs again
    if (state.hasLoaded) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    var year = DateTime.now().year;

    var results = await Future.wait([
      raceRepository.getUpcomingRaces(
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ),
      raceRepository.getRecentResult(),
      raceRepository.getDriverLeaderboard(year, {"limit": 3}),
    ]);

    final upcomingData = results[0].fold((failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
      return null;
    }, (data) => data as List<UpcomingRaceModel>);

    if (upcomingData == null) return;

    final recentData = results[1].fold((failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
      return null;
    }, (data) => data as RecentResultModel);

    if (recentData == null) return;

    final driverData = results[2].fold((failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
      return null;
    }, (data) => data as List<DriverLeaderBoardModel>);

    if (driverData == null) return;

    // Emit success state
    emit(
      state.copyWith(
        isLoading: false,
        hasLoaded: true,
        upcomingRaces: upcomingData,
        recentResults: recentData,
        driverLeaderboard: driverData,
      ),
    );
  }
}
