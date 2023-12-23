/// A placeholder class that represents an entity or model.
class GroceryItem {
  const GroceryItem(
    this.id,
    this.name,
    this.category,
    this.description,
  );

  final int id;
  final String name;
  final String category; // maybe use a number and have a list of Category
  final String? description;
}
