import 'dart:math';

final Random _random = Random();

const String _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

/// Generates a random alphanumeric id, used for Firestore document ids when
/// the user creates a food or meal without a server-assigned key.
String generateRandomId([int length = 20]) => String.fromCharCodes(
  Iterable.generate(
    length,
    (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
  ),
);
