enum BackupNetworkPolicy {
  wifiOnly,
  anyNetwork,
}

class BackupProfile {
  const BackupProfile({
    required this.id,
    required this.name,
    required this.qualityPercent,
    required this.networkPolicy,
    required this.requiresCharging,
  });

  final String id;
  final String name;
  final int qualityPercent;
  final BackupNetworkPolicy networkPolicy;
  final bool requiresCharging;
}
