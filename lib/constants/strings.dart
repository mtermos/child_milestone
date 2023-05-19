class Routes {
  static const String splashScreen = "/";
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String home = "/home";
  static const String milestone = "/milestone";
  static const String vaccine = "/vaccine";
  static const String childSummary = "/childSummaryRoute";
  static const String addChild = "/add_child";
  static const String editChild = "/edit_child";
  static const String settings = "/settings";
}

class Urls {
  static const String backend = "prepare.aubmc.org.lb";
  static const String apiVersion = "/api/v1/";

  static const String backendUrl = "https://prepare.aubmc.org.lb/api/v1/";
  // static const String backendUrl = "http://192.168.43.129:3000/api/";
  // static const String backendUrl = "http://127.0.0.1:8000/";
  static const String loginUrl = "user/login";
  static const String logoutUrl = "user/logout";
  static const String userUpdateUrl = "user/update";
  static const String createChildUrl = "child/add";
  static const String updateChildUrl = "child/update";
  static const String getChildUrl = "child/get";
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
  static const String userID = "user_id";
}
