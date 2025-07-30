import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateTawkHash(String userEmail, String secretKey) {
  // Convert the user ID and secret key to bytes
  final key = utf8.encode(secretKey);
  final data = utf8.encode(userEmail);

  // Generate the HMAC-SHA256 hash
  final hmac = Hmac(sha256, key); // Use HMAC-SHA256
  final digest = hmac.convert(data);

  // Return the hash as a hexadecimal string
  return digest.toString();
}