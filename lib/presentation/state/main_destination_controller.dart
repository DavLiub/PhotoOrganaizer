import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/main_destination.dart';

final mainDestinationProvider =
    NotifierProvider<MainDestinationController, MainDestination>(
      MainDestinationController.new,
    );

class MainDestinationController extends Notifier<MainDestination> {
  @override
  MainDestination build() {
    return MainDestination.home;
  }

  void select(MainDestination destination) {
    state = destination;
  }
}
