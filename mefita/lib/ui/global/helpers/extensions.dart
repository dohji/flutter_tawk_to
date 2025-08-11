extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

extension PhoneNumberCleanup on String {
  String removeNonNumericCharacters() {
    // Use a regular expression to replace all non-numeric characters with an empty string
    return this.replaceAll(RegExp(r'[^0-9]'), '');
  }
}