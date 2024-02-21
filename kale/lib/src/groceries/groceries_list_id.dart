import 'package:flutter/material.dart';
import 'package:kale/src/groceries/grocery_item.dart';
import 'package:kale/src/groceries/result.dart';
import 'action.dart' as kale; // TODO ok

class GroceriesListService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;
  Future<bool> fancyAnims() async => true;
  Future<List<GroceryItem>> items() async =>
      testItems(); // List.empty(growable: true);

  List<GroceryItem> testItems() {
    return <GroceryItem>[
      GroceryItem(1, 'white bread', 'pastry', null, true, null, null, "bob",
          DateTime.now()),
      GroceryItem(2, 'flavor bread', 'pastry', null, false, true, true, "alice",
          DateTime.now()),
      GroceryItem(3, 'cookies', 'deli', 'always could use cookies', false, null,
          null, "zelda", DateTime.now()),
      GroceryItem(4, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(5, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(6, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(7, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(8, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(9, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(10, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(11, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(12, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(13, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(14, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(15, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(16, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
      GroceryItem(17, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now()),
    ];
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<void> updateFancyAnims(bool option) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<Result<List<kale.Action>>> getActions(DateTime since) async {
    var dummyActions = <kale.Action>[
      kale.Action(1, DateTime.now(), "bob", "ADD", 1,
          '{ "id": 3, "name": "cookies", "category": "deli", "comments": "always could use cookies", "collected": false, "importance": null, "match": null, "addedBy": "zelda", "lastUpdated": "${DateTime.now()}"}')
    ];

    return Result(data: dummyActions);
  }

  Future<void> updateItem(GroceryItem item) async {
    print(item);
    print(GlobalObjectKey(item.id.toString())
        .currentContext); // TODO seem bad, modifiying the widget, not data
  }
}
