import 'dart:convert';

/// Redacts sensitive values before writing to debug logs.
class SensitiveLogSanitizer {
  static const _sensitiveBodyKeys = <String>{
    'pin',
    'password',
    'token',
    'authorization',
  };

  static Map<String, String> redactHeaders(Map<String, String> headers) {
    return headers.map((key, value) {
      if (key.toLowerCase() == 'authorization') {
        return MapEntry(key, 'Bearer [REDACTED]');
      }
      return MapEntry(key, value);
    });
  }

  static String? redactBody(String? body) {
    if (body == null || body.isEmpty) {
      return body;
    }

    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) {
        return json.encode(_redactMap(decoded));
      }
      if (decoded is List) {
        return json.encode(
          decoded.map((item) {
            if (item is Map<String, dynamic>) {
              return _redactMap(item);
            }
            return item;
          }).toList(),
        );
      }
    } catch (_) {
      return '[REDACTED_NON_JSON_BODY]';
    }

    return body;
  }

  static Map<String, dynamic> _redactMap(Map<String, dynamic> source) {
    final redacted = <String, dynamic>{};
    source.forEach((key, value) {
      if (_sensitiveBodyKeys.contains(key.toLowerCase())) {
        redacted[key] = '[REDACTED]';
      } else if (value is Map<String, dynamic>) {
        redacted[key] = _redactMap(value);
      } else {
        redacted[key] = value;
      }
    });
    return redacted;
  }
}
