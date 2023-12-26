import 'dart:ui';

import 'package:flutter/material.dart';

class TransformingButton extends StatefulWidget {
  final bool
      animsCoolThatWerePainToSetup; // this has a negative offset, which mobile cannot click
  final Widget? child;
  final Widget button;
  final Function? onAnimFinish;
  final bool Function()? shouldClose;
  final int milliseconds;
  final double position;
  final double width;
  final AnimationController Function(AnimationController controller)?
      animationBuilder;

  const TransformingButton(
      {super.key,
      this.animsCoolThatWerePainToSetup = true,
      this.child,
      required this.button,
      this.onAnimFinish,
      this.shouldClose,
      required this.milliseconds,
      required this.position,
      required this.width,
      this.animationBuilder});

  @override
  State<TransformingButton> createState() => _TransformingButtonState();
}

class _TransformingButtonState extends State<TransformingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animationScale;
  late Animation<double> animationTrans;

  var animWidth = 200.0;
  var animTrans = 0.0;

  var showChild = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.milliseconds), vsync: this);
    animationScale =
        Tween<double>(begin: 200, end: widget.width).animate(controller)
          ..addListener(() {
            setState(() {
              animWidth = animationScale.value;
            });
          });
    animationTrans =
        Tween<double>(begin: 0, end: widget.position).animate(controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object's value.
              animTrans = animationTrans.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (widget.onAnimFinish != null) {
                widget.onAnimFinish!();
              }
            } else if (status == AnimationStatus.dismissed) {
              showChild = false;
            }
          });

    if (widget.animationBuilder != null) {
      controller = widget.animationBuilder!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (showChild)
          Positioned(
            bottom: 0,
            child: Transform.translate(
              offset: Offset(
                  0, widget.animsCoolThatWerePainToSetup ? animTrans : 0),
              child: SizedBox(
                width: animWidth,
                child: TapRegion(
                  onTapOutside: (event) {
                    if (widget.shouldClose != null && widget.shouldClose!()) {
                      controller.reverse();
                    }
                  },
                  child: widget.child,
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
                showChild = true;
                controller.forward();
              },
              child: widget.button,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
