import 'package:flutter_provider_architecture/shared/global_config.dart';

class ApiConfig {
  static const String loginReq =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
  static const String singupReq =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
}
