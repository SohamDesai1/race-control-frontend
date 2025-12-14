class ApiRoutes {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String upcomingRaces = '/race/get_upcoming_race_data';
  static const String recentResults = '/race/get_race_results';
  static String driverLeaderboard(int year) => '/standings/driver_standings/$year';
  static String constructorLeaderboard(int year) => '/standings/constructor_standings/$year';
}
