class Action {
  final DateTime time;
  final String event;

  Action(this.time, this.event);

  @override
  String toString() {
    return 'time: "$time"; event: "$event"';
  }
}
