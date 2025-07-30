// import 'generate_hash.dart';
//
// /// Use [TawkVisitor] to set the visitor name and email.
// class TawkVisitor {
//   /// Visitor's name.
//   final String? name;
//
//   /// Visitor's email.
//   final String? email;
//
//   /// Other visitor attributes.
//   final Map<String, dynamic>? otherAttributes;
//
//   /// TAWK.to secret key
//   final String? secret;
//
//   TawkVisitor({
//     this.name,
//     this.email,
//     this.otherAttributes,
//     this.secret
//   });
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//
//
//     if (secret != null) {
//       data['hash'] = generateTawkHash(email!, secret!);
//       // data['hash'] = hash;
//     }
//
//     if (name != null) {
//       data['name'] = name;
//     }
//
//     if (email != null) {
//       data['email'] = email;
//     }
//
//     if (otherAttributes != null) {
//       data.addAll(otherAttributes!);
//     }
//
//     return data;
//   }
// }


/// A class representing a visitor for the Tawk.to chat service, used to set visitor attributes
/// such as name, email, and additional custom attributes, along with an optional secret key
/// for generating a secure hash.
import 'generate_hash.dart';

class TawkVisitor {
  /// The visitor's name.
  final String? name;

  /// The visitor's email address.
  final String? email;

  /// A map of additional visitor attributes to be sent to Tawk.to.
  final Map<String, dynamic>? otherAttributes;

  /// The Tawk.to secret key used for generating a secure hash for authentication.
  final String? secret;

  /// Creates a [TawkVisitor] instance with optional parameters for visitor details.
  ///
  /// Parameters:
  /// - `name`: The visitor's name (optional).
  /// - `email`: The visitor's email address (optional).
  /// - `otherAttributes`: A map of additional attributes to include (optional).
  /// - `secret`: The Tawk.to secret key for secure hash generation (optional).
  TawkVisitor({
    this.name,
    this.email,
    this.otherAttributes,
    this.secret,
  });

  /// Converts the [TawkVisitor] instance to a JSON-compatible map.
  ///
  /// If a `secret` and `email` are provided, a secure hash is generated using
  /// the [generateTawkHash] function and included in the output.
  /// The map includes the visitor's `name`, `email`, and `otherAttributes` if provided.
  ///
  /// Returns a `Map<String, dynamic>` containing the visitor's attributes.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (secret != null && email != null) {
      data['hash'] = generateTawkHash(email!, secret!);
    }

    if (name != null) {
      data['name'] = name;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (otherAttributes != null) {
      data.addAll(otherAttributes!);
    }

    return data;
  }
}