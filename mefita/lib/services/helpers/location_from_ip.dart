import 'package:dio/dio.dart';

/// Fetches the user's country data based on their IP address.
///
/// Tries `ipapi.co` first, then falls back to `ipinfo.io` if needed.
/// Returns a [Future] with a [Map] containing 'name' and 'isoCode' keys,
/// or throws an exception if both sources fail.
Future<Map<String, String>> getUserCountryFromIP() async {
  final dio = Dio();

  try {
    // First attempt: ipapi.co
    final response = await dio.get(
      'https://ipapi.co/json/',
      options: Options(
        headers: {'Accept': 'application/json'},
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return {'name': data['country_name'], 'code': data['country_code']};
    }
  } catch (e) {
    print('Primary API failed: $e');
  }

  try {
    // Fallback: ipinfo.io
    final response = await dio.get(
      'https://ipinfo.io/json',
      options: Options(
        headers: {'Accept': 'application/json'},
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final String isoCode = data['country'];

      return {'name': "", 'code': isoCode};
    }
  } catch (e) {
    print('Fallback API failed: $e');
  }

  throw Exception('Failed to get country data from both sources.');
}


// import 'package:dio/dio.dart';
//
// /// Fetches the user's country data based on their IP address.
// ///
// /// Uses a public IP geolocation API to determine the user's country.
// /// No parameters needed as it uses the requesting IP automatically.
// ///
// /// Returns a [Future] with a [Map] containing 'name' and 'isoCode' keys,
// /// or throws an exception if the request fails.
// Future<Map<String, String>> getUserCountryFromIP() async {
//   final dio = Dio();
//
//   try {
//     // Make GET request to a free IP geolocation API
//     // Note: For production, consider using a more reliable API with appropriate usage terms
//     final response = await dio.get(
//       'https://ipapi.co/json/',
//       options: Options(
//         headers: {
//           'Accept': 'application/json',
//         },
//         responseType: ResponseType.json,
//       ),
//     );
//
//     // Check if response is successful
//     if (response.statusCode == 200) {
//       final data = response.data;
//
//       // Extract country name and ISO code from response
//       // Different APIs may use different field names
//       final String name = data['country_name'];
//       final String isoCode = data['country_code'];
//
//       return {
//         'name': name,
//         'isoCode': isoCode,
//       };
//     } else {
//       throw DioException(
//         requestOptions: response.requestOptions,
//         response: response,
//         message: 'Failed to get country data. Status: ${response.statusCode}',
//       );
//     }
//   } on DioException catch (e) {
//     print('Dio error: ${e.message}');
//     throw e;
//   } catch (e) {
//     print('Unexpected error: $e');
//     throw Exception('Failed to get country data: $e');
//   }
// }
//
// /// Alternative implementation using ipinfo.io as the geolocation provider
// Future<Map<String, String>> getUserCountryFromIPAlternative() async {
//   final dio = Dio();
//
//   try {
//     // Use ipinfo.io as an alternative
//     // For production use, get a token from https://ipinfo.io/
//     final response = await dio.get(
//       'https://ipinfo.io/json',
//       options: Options(
//         headers: {
//           'Accept': 'application/json',
//           // Add your token here for production use
//           // 'Authorization': 'Bearer your_token_here',
//         },
//         responseType: ResponseType.json,
//       ),
//     );
//
//     if (response.statusCode == 200) {
//       final data = response.data;
//
//       // ipinfo.io provides country code but not full name
//       final String isoCode = data['country'];
//
//       // We need to map the country code to a name
//       // In a real app, you would use a lookup table or another API call
//       // This is a simplified example
//       final Map<String, String> countryNames = {
//         'US': 'United States',
//         'GB': 'United Kingdom',
//         'CA': 'Canada',
//         // Add more countries as needed
//       };
//
//       final String name = countryNames[isoCode] ?? 'Unknown Country';
//
//       return {
//         'name': name,
//         'isoCode': isoCode,
//       };
//     } else {
//       throw DioException(
//         requestOptions: response.requestOptions,
//         response: response,
//         message: 'Failed to get country data. Status: ${response.statusCode}',
//       );
//     }
//   } on DioException catch (e) {
//     print('Dio error: ${e.message}');
//     throw e;
//   } catch (e) {
//     print('Unexpected error: $e');
//     throw Exception('Failed to get country data: $e');
//   }
// }
