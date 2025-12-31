class ApiRoutes {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static String upcomingRaces(String date) =>
      '/race/get_upcoming_race_data/$date';
  static const String recentResults = '/race/get_race_results';
  static String driverLeaderboard(int year) =>
      '/standings/driver_standings/$year';
  static String constructorLeaderboard(int year) =>
      '/standings/constructor_standings/$year';
  static String raceDetails(String year, String round) =>
      '/race/get_race_data/$year/$round';
  static String raceSessions(String raceId, String year) =>
      '/session/get_sessions/$raceId/$year';
  static String allRacesInSeason(String year) =>
      '/race/get_all_races_data/$year';
  static String sessionDetails(String sessionId) =>
      '/session/get_session_data/$sessionId';
  static String driverTelemetryData(String sessionId, String driverNumber) =>
      '/session/fetch_driver_telemetry/$sessionId/$driverNumber';
}
