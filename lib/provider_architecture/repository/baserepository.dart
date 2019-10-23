import 'exception.dart';

class BaseRepository {
  DataException getErrorBasedOnStatusCode(int statusCode, String message) {
    // If that response was not OK, throw an error.
    if (statusCode == 500 || statusCode == 404) {
      return new DataException(
          "Unable to login. Internal Server error. Kindly report to system admin.",
          statusCode);
    } else if (statusCode == 503) {
      return new DataException(
          "Unable to login. Server is down for maintainence. Kindly try after some time.",
          statusCode);
    } else if (message.contains("SocketException")) {
      return new DataException(
          "Unable to authenticate user [StatusCode:$statusCode, Error:$message]",
          statusCode);
    }

    return new DataException(
        "Unable to authenticate user [StatusCode:$statusCode, Error:$message]",
        statusCode);
  }
}
