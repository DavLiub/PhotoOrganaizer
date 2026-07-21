enum CloudAccountStatus {
  connected,
  expired,
  revoked,
  disconnected,
}

class CloudAccount {
  const CloudAccount({
    required this.id,
    required this.providerId,
    required this.externalAccountId,
    required this.status,
    this.displayName,
  });

  final String id;
  final String providerId;
  final String externalAccountId;
  final CloudAccountStatus status;
  final String? displayName;
}
