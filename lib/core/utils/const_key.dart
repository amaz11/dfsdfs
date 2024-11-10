// ignore: constant_identifier_names
enum AppConstantkey { TOKEN, FIRST_LOGIN, USERNAME, PROFILE_IMG, DESIGNATION }

extension AppConstantExtension on AppConstantkey {
  String get key {
    switch (this) {
      case AppConstantkey.TOKEN:
        return "X_toke_treal";
      case AppConstantkey.FIRST_LOGIN:
        return "X_first_login_treal";
      case AppConstantkey.USERNAME:
        return "X_USER_NAME";
      case AppConstantkey.PROFILE_IMG:
        return "X_PROFILE_IMG";
      case AppConstantkey.DESIGNATION:
        return "X_DESIGNATION";
    }
  }
}
