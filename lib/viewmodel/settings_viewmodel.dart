import 'package:flutter/cupertino.dart';

import '../config/sp_helper.dart';

class SettingsViewModel with ChangeNotifier {
  bool _isFirstTaskEntryToggled = false;

  bool get isFirstTaskEntryToggled => _isFirstTaskEntryToggled;

  void loadFirstTaskEntryToggleFlag() async {
    bool flag = await SPHelper().getFirstTaskEntryFlag();
    _isFirstTaskEntryToggled = flag;
    notifyListeners();
  }

  void toggleFirstTaskEntryFlag() {
    _isFirstTaskEntryToggled = !_isFirstTaskEntryToggled;
    SPHelper().saveFirstTaskEntryFlag(_isFirstTaskEntryToggled);
    notifyListeners();
  }
}
