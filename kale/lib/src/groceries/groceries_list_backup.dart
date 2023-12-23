import 'dart:ui';

import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  static const routeName = '/';

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList>
    with SingleTickerProviderStateMixin {
  List<GroceryItem> items = const [
    GroceryItem(1, 'white bread', '', null),
    GroceryItem(2, 'flavor bread', '', null),
    GroceryItem(3, 'cookies', '', null),
    GroceryItem(4, 'frozen dinner', '', null)
  ];

  late Animation<double> animationScale;
  late Animation<double> animationTrans;
  late AnimationController controller;
  var animWidth = 200.0;
  var animTrans = 0.0;
  var showAddItem = false;

  late FocusNode focusAddItem;

  @override
  void initState() {
    super.initState();

    focusAddItem = FocusNode()
      ..addListener(() {
        if (!focusAddItem.hasFocus) {
          controller.reverse();
          showAddItem = false;
        }
      });

    // final maxWdith = MediaQuery.of(context).size.width;
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    // Dimensions in logical pixels (dp)
    Size size = view.physicalSize / view.devicePixelRatio;
    final maxWidth = size.width;
    final maxHeight = size.height;

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animationScale =
        Tween<double>(begin: 200, end: maxWidth).animate(controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object's value.
              animWidth = animationScale.value;
            });
          });
    animationTrans =
        Tween<double>(begin: 0, end: -maxHeight / 3).animate(controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object's value.
              animTrans = animationTrans.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && !showAddItem) {
              showAddItem = true;
              focusAddItem.requestFocus();
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
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
      body: Column(children: [
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
                  onTap: () {}),
              onDismissed: (direction) {
                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.id} dismissed $direction')));
              },
            );
          },
        )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              if (showAddItem)
                Column(
                  children: [
                    // TODO swap button and text
                    TextField(
                      focusNode: focusAddItem,
                      cursorColor: Colors.green,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent)),
                        hintText: 'Item',
                      ),
                    )
                  ],
                )
              else
                Transform.translate(
                  offset: Offset(0, animTrans),
                  child: SizedBox(
                      width: animWidth,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                            backgroundColor: Colors.greenAccent),
                        onPressed: () {
                          controller.forward();
                        },
                        child: const Text('Add Item'),
                      )),
                ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusAddItem.dispose();
    super.dispose();
  }
}
