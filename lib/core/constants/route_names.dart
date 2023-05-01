class RouteNames {
  static const Routes withPrefix = Routes(
    home: '/',
    students: '/students',
    settings: '/settings',
    profile: '/profile',
    yourInfo: '/your-info',
    sessions: '/sessions',
    login: '/login',
    resetPassword: '/reset-password',
    signUp: '/signup',
  );
  static const Routes withoutPrefix = Routes(
    home: '',
    students: 'students',
    settings: 'settings',
    profile: 'profile',
    yourInfo: 'your-info',
    sessions: 'sessions',
    login: 'login',
    resetPassword: 'reset-password',
    signUp: 'signup',
  );
}

class Routes {
  final String home;
  final String students;
  final String settings;
  final String profile;
  final String yourInfo;
  final String sessions;

  /// Auth routes
  final String login;
  final String signUp;
  final String resetPassword;

  const Routes({
    required this.home,
    required this.students,
    required this.settings,
    required this.profile,
    required this.yourInfo,
    required this.sessions,
    required this.login,
    required this.resetPassword,
    required this.signUp,
  });
}
