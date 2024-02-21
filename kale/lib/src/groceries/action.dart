class Action {
  // metadata
  final int id;
  final DateTime time;
  final String username;

  // item info
  final String event;
  final int itemId;
  final String? content;

  Action(
      this.id, this.time, this.username, this.event, this.itemId, this.content);

  @override
  String toString() {
    return 'id: "$id"; time: "$time"; username: "$username"; event: "$event"; item_id: "$itemId"; content: "$content"';
  }
}
