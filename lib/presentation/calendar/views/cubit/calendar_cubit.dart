import 'package:bloc/bloc.dart';
import 'package:frontend/models/race_details.dart';
import 'package:frontend/repositories/race_repository.dart';
import 'package:injectable/injectable.dart';
part 'calendar_state.dart';

@injectable
class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(this.raceRepository) : super(CalendarState());

  final RaceRepository raceRepository;

  Future<void> loadCalendarData(String year) async {
    final cacheKey = year;
    if (state.isCached(year)) {
      final cachedData = state.cache[cacheKey]!;
      emit(
        state.copyWith(
          calendarRaces: cachedData,
          currentKey: cacheKey,
          isLoading: false,
          error: null,
        ),
      );
      return;
    }
    emit(state.copyWith(isLoading: true));
    final racesResult = await raceRepository.getCalendar(year);
    racesResult.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (racesData) {
        final updatedCache = Map<String, List<RaceModel>>.from(state.cache);
        updatedCache[cacheKey] = racesData;
        emit(
          state.copyWith(
            isLoading: false,
            hasLoaded: true,
            calendarRaces: racesData,
            cache: updatedCache,
            currentKey: cacheKey,
            error: null,
          ),
        );
      },
    );
  }
}
