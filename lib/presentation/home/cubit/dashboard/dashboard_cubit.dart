import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../models/upcoming_race.dart';
import '../../../../repositories/race_repository.dart';
import 'package:meta/meta.dart';
part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.raceRepository) : super(DashboardInitial());

  final RaceRepository raceRepository;

  Future<void> fetchUpcomingRaces() async {
    try {
      emit(DashboardLoading());
      final result = await raceRepository.getUpcomingRaces();
      result.fold((failure) {
        emit(DashboardError(failure.message));
      }, (races) => emit(DashboardSuccess(races)));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
