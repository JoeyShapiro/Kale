/// A placeholder class that represents an entity or model.
class GroceryItem {
  GroceryItem(this.id, this.name, this.category, this.comments, this.collected,
      this.importance, this.match, this.addedBy, this.lastUpdated);

  final int id;
  final String name;
  final String category; // maybe use a number and have a list of Category
  final String? comments;
  final bool collected;

  // these are clever
  /*
    true = important
    false = not important
    null = normal
  */
  bool? importance;
  bool? match;

  final String addedBy;
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'id: "$id"; name: "$name"; category: "$category"; comments: "$comments"; collected: "$collected"; '
        'importance: "$importance"; match: "$match"; '
        'addedBy: "$addedBy"; lastUpdated: "$lastUpdated"';
  }
}
