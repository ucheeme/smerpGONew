import 'dart:convert';

/// Helpers for values persisted through [SharedPref.save].
class SharedPrefStringCodec {
  SharedPrefStringCodec._();

  static String? decode(String raw) {
    if (raw.isEmpty) {
      return null;
    }

    if (raw.startsWith('"') && raw.endsWith('"') && raw.length >= 2) {
      return raw.substring(1, raw.length - 1);
    }

    try {
      final decoded = json.decode(raw);
      if (decoded is String) {
        return decoded;
      }
    } catch (_) {
      return raw;
    }

    return raw;
  }
}
