import 'package:flutter/material.dart';

class NullSwitch extends StatefulWidget {
  final Widget? Function(BuildContext context, bool? state) iconBuilder;
  final Function(bool? state)? onSwtich;
  final ButtonStyle? style;

  const NullSwitch(
      {super.key, required this.iconBuilder, this.onSwtich, this.style});

  @override
  State<NullSwitch> createState() => _NullSwitchState();
}

class _NullSwitchState extends State<NullSwitch> {
  bool? state;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: () {
        // cool
        setState(() {
          // get the next state
          if (state == null) {
            state = true;
          } else if (state!) {
            state = false;
          } else if (!state!) {
            state = null;
          }
        });

        // do the user defined function
        if (widget.onSwtich != null) widget.onSwtich!(state);
      },
      child: widget.iconBuilder(context, state),
    );
  }
}
