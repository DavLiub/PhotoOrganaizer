import '../../domain/models/protection_summary.dart';

class ObserveProtectionSummaryUseCase {
  ObserveProtectionSummaryUseCase({required ProtectionSummary initialSummary})
    : _initialSummary = initialSummary;

  final ProtectionSummary _initialSummary;

  Stream<ProtectionSummary> call() {
    return Stream.value(_initialSummary);
  }
}
