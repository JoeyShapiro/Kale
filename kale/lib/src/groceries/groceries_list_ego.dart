import 'package:flutter/material.dart';
import 'package:kale/src/groceries/grocery_item.dart';

import 'groceries_list_id.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class GroceriesListController with ChangeNotifier {
  GroceriesListController(this._groceriesListService);

  // Make SettingsService a private variable so it is not used directly.
  final GroceriesListService _groceriesListService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late bool _fancyAnims;
  late List<GroceryItem> _items;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  bool get fancyAnims => _fancyAnims;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _groceriesListService.themeMode();
    _fancyAnims = await _groceriesListService.fancyAnims();
    _items = await _groceriesListService.items();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _groceriesListService.updateThemeMode(newThemeMode);
  }

  Future<void> updateFancyAnims(bool? newOption) async {
    if (newOption == null) return;

    if (newOption == _fancyAnims) return;

    _fancyAnims = newOption;

    notifyListeners();

    await _groceriesListService.updateFancyAnims(newOption);
  }

  Future<void> updateItem(GroceryItem item) async {
    for (var i = 0; i < _items.length; i++) {
      if (item.id == _items[i].id) {
        _items[i] = item;
        break;
      }
    }

    notifyListeners();

    await _groceriesListService.updateItem(item);
  }
}
