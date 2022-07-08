const String SHARED_LOGGED = "USER_IS_LOGGED";
const String SHARED_USER = "USER";
const String SHARED_PASSWORD = "PASSWORD";
const String SELECTED_CHILD_ID = "SELECTED_CHILD_ID";

class Routes {
  static const String splashScreen = "/";
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String home = "/home";
  static const String milestone = "/milestone";
  static const String childSummary = "/childSummaryRoute";
  static const String addChild = "/add_child";
  static const String settings = "/settings";
}

class Urls {
  static const String backendUrl = "http://localhost:3000/api";
  static const String loginUrl = "/user/login";
}
