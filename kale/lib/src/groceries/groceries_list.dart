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
  late Animation<double> animationBlur;
  late AnimationController controller;
  var animWidth = 200.0;
  var animTrans = 0.0;
  var showAddItem = false;
  var blur = 0.0;
  var showButtons = false;
  late List<String> categories;
  final animsCoolThatWerePainToSetup =
      true; // this has a negative offset, which mobile cannot click

  late FocusNode focusAddItem;
  late FocusNode focusDropdown; // TODO might have to change for new idea
  var addItemDropdown = false;

  @override
  void initState() {
    super.initState();

    focusAddItem = FocusNode();

    // final maxWdith = MediaQuery.of(context).size.width;
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    // Dimensions in logical pixels (dp)
    Size size = view.physicalSize / view.devicePixelRatio;
    final maxWidth = size.width;
    final maxHeight = size.height;

    categories = <String>[
      'deli',
      'frozen',
      'pastry',
    ];

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
    animationBlur = Tween<double>(begin: 0, end: 5).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
          blur = animationBlur.value;
        });
      });
    animationTrans =
        Tween<double>(begin: 0, end: -maxHeight / 2).animate(controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object's value.
              animTrans = animationTrans.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              focusAddItem.requestFocus();
              showButtons = true;
            } else if (status == AnimationStatus.dismissed) {
              showAddItem = false;
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: !animsCoolThatWerePainToSetup,
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
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                restorationId: 'sampleItemListView',
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return Dismissible(
                    key: Key(item.id.toString()),
                    background: Container(color: Colors.green),
                    child: ListTile(
                        title: Text(item.name),
                        leading: const CircleAvatar(
                          // Display the Flutter Logo image asset.
                          foregroundImage:
                              AssetImage('assets/images/flutter_logo.png'),
                        ),
                        onTap: () {}),
                    onDismissed: (direction) {
                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${item.id} dismissed $direction')));
                    },
                  );
                },
              ),
            )),
          ],
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (showAddItem)
              Positioned(
                bottom: 0,
                child: Transform.translate(
                  offset:
                      Offset(0, animsCoolThatWerePainToSetup ? animTrans : 0),
                  child: SizedBox(
                    width: animWidth,
                    child: TapRegion(
                      onTapOutside: (event) {
                        if (!addItemDropdown) {
                          controller.reverse();
                          showButtons = false;
                        }
                      },
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
                                focusNode: focusAddItem,
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
                                          TextEditingController
                                              textEditingController,
                                          FocusNode focusNode,
                                          VoidCallback onFieldSubmitted,
                                        ) {
                                          focusNode.addListener(() {
                                            addItemDropdown =
                                                focusNode.hasFocus;
                                          });
                                          return TextFormField(
                                            decoration: const InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.greenAccent)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.greenAccent)),
                                              hintText: 'Category',
                                            ),
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            onFieldSubmitted: (String value) {
                                              onFieldSubmitted();
                                            },
                                          );
                                        },
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return categories
                                              .where((String option) {
                                            return option.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (String selection) {
                                          debugPrint(
                                              'You just selected $selection');
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
                                          print('add');
                                        },
                                        child: const Text('+')),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.greenAccent),
                  onPressed: () {
                    showAddItem = true;
                    controller.forward();
                  },
                  child: const Text('Add Item'),
                ),
              ),
          ],
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
