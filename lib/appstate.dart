import 'dart:collection';
import 'package:flutter/material.dart';

import 'data.service.dart';

// This is shared state
class MyAppState extends ChangeNotifier {
  List<CoolDude> _coolDudes = []; // _ means private to this class
  List<CoolDude> _uncoolDudes = [];
  UnmodifiableListView<CoolDude> coolDudes; // public immutable view
  UnmodifiableListView<CoolDude> uncoolDudes; // public immutable view

  late DataService _dataService;

  // Weird, surely this isn't how it's done?
  MyAppState(DataService dataService)
      : coolDudes = UnmodifiableListView<CoolDude>([]),
        uncoolDudes = UnmodifiableListView<CoolDude>([]) {
    _dataService = dataService;
    coolDudes = UnmodifiableListView(_coolDudes);
    uncoolDudes = UnmodifiableListView(_uncoolDudes);
  }

  Future<void> initialiseState() async {
    await _dataService.initialiseDatabase();
    await updateViews();
  }

  Future<void> updateViews() async {
    _coolDudes = await _dataService.getCoolDudes();
    _uncoolDudes = await _dataService.getUncoolDudes();

    coolDudes = UnmodifiableListView(_coolDudes);
    uncoolDudes = UnmodifiableListView(_uncoolDudes);

    notifyListeners();
  }

  Future<void> addADude(CoolDude dude) async {
    await _dataService.addADude(dude);
    await updateViews();

    // Notifies the providers (only one in this case)
    notifyListeners();
  }

  Future<void> deleteADude(CoolDude dude) async {
    await _dataService.deleteADude(dude);
    await updateViews();

    notifyListeners();
  }

  int getNextId() {
    if (coolDudes.isEmpty && uncoolDudes.isEmpty) {
      return 1;
    }

    final latestId = [...coolDudes, ...uncoolDudes]
        .reduce((curr, next) => curr.id > next.id ? curr : next);
    return latestId.id + 1;
  }
}
