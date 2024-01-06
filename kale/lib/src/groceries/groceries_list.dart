import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../settings/settings_controller.dart';

import '../settings/settings_view.dart';
import 'grocery_item.dart';
import 'transforming_button.dart';

class GroceryList extends StatefulWidget {
  final SettingsController settings;

  const GroceryList({super.key, required this.settings});

  static const routeName = '/';

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  late List<GroceryItem> items;
  late List<String> categories;

  var blur = 0.0;
  late FocusNode focusAddItem;
  late FocusNode focusDropdown;
  late Animation<double> animationBlur;

  var showButtons = false;
  var addItemDropdown = false;

  late double maxWidth;
  late double position;

  late TextEditingController itemName;
  late TextEditingController itemCategory;

  @override
  void initState() {
    super.initState();

    // final maxWdith = MediaQuery.of(context).size.width;
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    // Dimensions in logical pixels (dp)
    Size size = view.physicalSize / view.devicePixelRatio;
    maxWidth = size.width;
    final maxHeight = size.height;
    position = -maxHeight / 2;

    categories = <String>[
      'deli',
      'frozen',
      'pastry',
    ];

    items = <GroceryItem>[
      GroceryItem(1, 'white bread', 'pastry', null, true, null, null, "bob",
          DateTime.now()),
      GroceryItem(2, 'flavor bread', 'pastry', null, false, true, true, "alice",
          DateTime.now()),
      GroceryItem(3, 'cookies', 'deli', 'always could use cookies', false, null,
          null, "zelda", DateTime.now()),
      GroceryItem(4, 'frozen dinner', 'frozen', 'something different', false,
          false, null, "bob", DateTime.now())
    ];

    focusAddItem = FocusNode();
    itemName = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: !widget.settings.fancyAnims,
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
      body: Stack(alignment: Alignment.bottomCenter, children: [
        // BackdropFilter(filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), child: ???), // TODO has to be below child
        Column(
          children: [
            Expanded(
                child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: ListView.builder(
                  itemCount: categories.length + 1, // 1 is for collected
                  itemBuilder: (BuildContext context, int index) {
                    if (index < categories.length) {
                      // if a normal category
                      final categoryItems = items
                          .where(
                            (element) =>
                                (element.category == categories[index] &&
                                    !element.collected),
                          )
                          .toList(growable: false);
                      return Column(
                        children: [
                          Text(categories[index]),
                          const Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            // Providing a restorationId allows the ListView to restore the
                            // scroll position when a user leaves and returns to the app after it
                            // has been killed while running in the background.
                            restorationId: 'sampleItemListView',
                            itemCount: categoryItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = categoryItems[index];

                              return Dismissible(
                                key: Key(item.id.toString()),
                                background: Container(
                                  color: Colors.green,
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.front_hand_rounded,
                                      ),
                                      Icon(
                                        Icons.check,
                                      ),
                                    ],
                                  ),
                                ),
                                child: ListTile(
                                    title: Text(item.name),
                                    subtitle: item.comments != null
                                        ? Text(item.comments!)
                                        : null,
                                    leading: const CircleAvatar(
                                      // Display the Flutter Logo image asset.
                                      foregroundImage: AssetImage(
                                          'assets/images/flutter_logo.png'),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AboutDialog(
                                            applicationName: "View Item",
                                            children: [
                                              Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Name"),
                                                    Text(item.name),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Category"),
                                                    Text(item.category),
                                                  ],
                                                ),
                                                const Divider(),
                                                const Text("Comments"),
                                                Text(item.comments ?? ""),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(item.addedBy),
                                                    Text(DateFormat(
                                                            "MM-dd-yy kk:mm")
                                                        .format(
                                                            item.lastUpdated)),
                                                  ],
                                                ),
                                              ])
                                            ],
                                          );
                                        },
                                      );
                                    }),
                                onDismissed: (direction) {
                                  final success = items.remove(item);
                                  if (!success) {
                                    // only show snackbar for error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'error: $success: ${item.id} dismissed $direction')));
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      final collectedItems = items
                          .where(
                            (element) => element.collected,
                          )
                          .toList(growable: false);
                      return Column(
                        children: [
                          const Text("collected"),
                          const Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            // Providing a restorationId allows the ListView to restore the
                            // scroll position when a user leaves and returns to the app after it
                            // has been killed while running in the background.
                            restorationId: 'sampleItemListView',
                            itemCount: collectedItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = collectedItems[index];

                              return Dismissible(
                                key: Key(item.id.toString()),
                                background: Container(
                                  color: Colors.yellow,
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.front_hand_rounded,
                                      ),
                                      Icon(
                                        Icons.cancel,
                                      ),
                                    ],
                                  ),
                                ),
                                child: ListTile(
                                    title: RichText(
                                      text: TextSpan(
                                        text: item.name,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                    subtitle: item.comments != null
                                        ? Text(item.comments!)
                                        : null,
                                    leading: const CircleAvatar(
                                      // Display the Flutter Logo image asset.
                                      foregroundImage: AssetImage(
                                          'assets/images/flutter_logo.png'),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AboutDialog(
                                            applicationName: "View Item",
                                            children: [
                                              Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Name"),
                                                    Text(item.name),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Category"),
                                                    Text(item.category),
                                                  ],
                                                ),
                                                const Divider(),
                                                const Text("Comments"),
                                                Text(item.comments ?? ""),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(item.addedBy),
                                                    Text(DateFormat(
                                                            "MM-dd-yy kk:mm")
                                                        .format(
                                                            item.lastUpdated)),
                                                  ],
                                                ),
                                              ])
                                            ],
                                          );
                                        },
                                      );
                                    }),
                                onDismissed: (direction) {
                                  final success = items.remove(item);
                                  if (!success) {
                                    // only show snackbar for error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'error: $success: ${item.id} dismissed $direction')));
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }
                  }),
            )),
          ],
        ),
        TransformingButton(
          animsCoolThatWerePainToSetup: widget.settings.fancyAnims,
          animationBuilder: (controller) {
            animationBlur = Tween<double>(begin: 0, end: 5).animate(controller)
              ..addListener(() {
                setState(() {
                  // The state that has changed here is the animation object's value.
                  blur = animationBlur.value;
                });
              });

            return controller;
          },
          milliseconds: 300,
          width: maxWidth,
          position: position,
          shouldClose: () {
            if (!addItemDropdown) {
              showButtons = false;
            }
            return !addItemDropdown;
          },
          onAnimFinish: () {
            focusAddItem.requestFocus();
            showButtons = true;
          },
          button: const Text('Add Item'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: itemName,
                    focusNode: focusAddItem,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          borderSide: BorderSide(color: Colors.greenAccent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          borderSide: BorderSide(color: Colors.greenAccent)),
                      hintText: 'New Item...',
                    ),
                  ),
                  if (showButtons)
                    Row(
                      children: [
                        Flexible(
                          child: Autocomplete<String>(
                            // TODO maybe do raw
                            fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              focusNode.addListener(() {
                                addItemDropdown = focusNode.hasFocus;
                              });
                              itemCategory = textEditingController;

                              return TextFormField(
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent)),
                                  hintText: 'Category',
                                ),
                                controller: textEditingController,
                                focusNode: focusNode,
                                onFieldSubmitted: (String value) {
                                  onFieldSubmitted();
                                },
                              );
                            },
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return const Iterable<String>.empty();
                              }
                              return categories.where((String option) {
                                return option.contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              debugPrint('You just selected $selection');
                            },
                          ),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ))),
                            onPressed: () {
                              print('comment');
                            },
                            child: const Text('Comments')),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(25.0)),
                            ))),
                            onPressed: () {
                              final name = itemName.text;
                              final category = itemCategory.text;
                              final comments = '';
                              print('add "$name" "$category" "$comments"');
                              items.add(GroceryItem(
                                  -1,
                                  name,
                                  category,
                                  comments,
                                  false,
                                  null,
                                  null,
                                  "bob",
                                  DateTime.now()));

                              itemName.text = '';
                              itemCategory.text = '';
                            },
                            child: const Text('+')),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    focusDropdown.dispose();
    focusAddItem.dispose();

    itemName.dispose();

    super.dispose();
  }
}
