import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [
      SampleItem(1),
      SampleItem(2),
      SampleItem(3),
      SampleItem(4)
    ],
  });

  static const routeName = '/sample';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'sampleItemListView',
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];

              return Dismissible(
                key: Key(item.id.toString()),
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.green),
                child: ListTile(
                    title: Text('SampleItem ${item.id}'),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      // Navigate to the details page. If the user leaves and returns to
                      // the app after it has been killed while running in the
                      // background, the navigation stack is restored.
                      Navigator.restorablePushNamed(
                        context,
                        SampleItemDetailsView.routeName,
                      );
                    }),
                onDismissed: (direction) {
                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${item.id} dismissed $direction')));
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.black),
                onPressed: () {
                  // newItemDialog(context);
                },
                child: const Text('Add Item'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> newItemDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: const Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: "Name"),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Description"),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  print('hello');
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
