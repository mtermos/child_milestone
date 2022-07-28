class Routes {
  static const String splashScreen = "/";
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String home = "/home";
  static const String milestone = "/milestone";
  static const String childSummary = "/childSummaryRoute";
  static const String addChild = "/add_child";
  static const String editChild = "/edit_child";
  static const String settings = "/settings";
}

class Urls {
  static const String backendUrl = "http://localhost:3000/api";
  static const String loginUrl = "/user/login";
}

class StorageKeys {
  static const String username = "username";
  static const String password = "password";
}

class SharedPrefKeys {
  static const String isLogged = "logged";
  static const String accessToken = "access_token";
  static const String selectedChildId = "selectedChildId";
  static const String langCode = "lang";
}

List<String> Categories = [
  ""
];
