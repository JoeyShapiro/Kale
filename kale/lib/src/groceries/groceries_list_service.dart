import 'package:flutter/material.dart';
import 'package:kale/src/groceries/grocery_item.dart';

class GroceriesListService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;
  Future<bool> fancyAnims() async => true;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<void> updateFancyAnims(bool option) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<void> updateItem(GroceryItem item) async {
    print(item);
    print(GlobalObjectKey(item.id.toString())
        .currentContext); // TODO seem bad, modifiying the widget, not data
  }
}
