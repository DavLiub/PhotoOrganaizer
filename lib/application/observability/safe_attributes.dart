Map<String, Object?> safeAttributes(Map<String, Object?> attributes) {
  final result = <String, Object?>{};

  for (final entry in attributes.entries) {
    final key = entry.key.trim();
    if (key.isEmpty || _isSensitiveKey(key)) {
      continue;
    }

    final value = _safeValue(entry.value);
    if (value != null || entry.value == null) {
      result[key] = value;
    }
  }

  return Map.unmodifiable(result);
}

bool _isSensitiveKey(String key) {
  final normalized = key.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
  const markers = [
    'path',
    'uri',
    'url',
    'filename',
    'displayname',
    'exif',
    'location',
    'latitude',
    'longitude',
    'gps',
    'email',
    'token',
    'secret',
    'password',
    'apikey',
    'privatekey',
    'credential',
    'accountid',
    'cloudobjectid',
    'mediaid',
  ];

  return markers.any(normalized.contains);
}

Object? _safeValue(Object? value) {
  if (value == null ||
      value is bool ||
      value is num ||
      value is DateTime ||
      value is Enum) {
    return value;
  }

  if (value is String) {
    return _looksSensitiveText(value) ? null : value;
  }

  return null;
}

bool _looksSensitiveText(String value) {
  final lower = value.toLowerCase();
  final normalized = lower.replaceAll(RegExp('[^a-z0-9]'), '');

  return RegExp(r'^[a-z]:[\\/]').hasMatch(lower) ||
      lower.contains('/storage/') ||
      lower.contains('/dcim/') ||
      normalized.contains('apikey') ||
      normalized.contains('clientsecret') ||
      normalized.contains('privatekey') ||
      lower.contains('@');
}
