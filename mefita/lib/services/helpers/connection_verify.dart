
import 'dart:io';

class ConnectionVerify {
  /// The response depends on an asynchronous result
  static Future<bool> connectionIsAvailable() async {
    /// Here, the result works like a 'ping' at the address below
    try {
      /// It's used 'example.com' because it has a global range
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        /// CONNECTED
        /// Here it's returned 'true', so the response of 'lookup' was sucessful
        return true;
      }
      return false;
    } on SocketException catch (_) {
      /// NOT CONNECTED
      /// Here the 'lookup' returned and exception, so there is not connection
      return false;
    }
  }
}



