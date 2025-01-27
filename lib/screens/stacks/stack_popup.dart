import 'package:cred/utils/media_query.dart';
import 'package:flutter/material.dart';

class StackPopup extends StatefulWidget {
  final AnimationController slideController;
  final Animation<double> slideAnimation;
  final Function animCompleteCallback;
  final Function animReversedCallBack;
  Widget child;
  final int screenNumber;

  StackPopup(
      {Key? key,
      required this.slideController,
      required this.slideAnimation,
      required this.animCompleteCallback,
      required this.animReversedCallBack,
      required this.child,
      required this.screenNumber})
      : super(key: key);

  @override
  State<StackPopup> createState() => _StackPopupState();
}

class _StackPopupState extends State<StackPopup> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.animCompleteCallback();
      } else if (status == AnimationStatus.dismissed) {
        widget.animReversedCallBack();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.slideController.forward(from: 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: widget.slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
                0.0,
                MediaQuery.of(context).size.height *
                    (1 - widget.slideAnimation.value)),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(131, 10, 45, 74),
                  border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(MediaQueryUtil.getValueInPixel(100)),
                    topRight:
                        Radius.circular(MediaQueryUtil.getValueInPixel(100)),
                  ),
                ),
                child: widget.child),
          );
        },
      ),
    );
  }
}
