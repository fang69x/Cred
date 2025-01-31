import 'dart:ui';
import 'package:cred/core/constants/media_query.dart';
import 'package:flutter/material.dart';

class StackPopup extends StatefulWidget {
  final AnimationController slideController;
  final Animation<double> slideAnimation;
  final Function animCompleteCallback;
  final Function animReversedCallBack;
  final Widget child;
  final int screenNumber;

  const StackPopup({
    Key? key,
    required this.slideController,
    required this.slideAnimation,
    required this.animCompleteCallback,
    required this.animReversedCallBack,
    required this.child,
    required this.screenNumber,
  }) : super(key: key);

  @override
  State<StackPopup> createState() => _StackPopupState();
}

class _StackPopupState extends State<StackPopup> with TickerProviderStateMixin {
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.slideController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.slideController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

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
                  0.9 *
                  (1 - widget.slideAnimation.value),
            ),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: _buildPopupContainer(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopupContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQueryUtil.getValueInPixel(40)),
          topRight: Radius.circular(MediaQueryUtil.getValueInPixel(40)),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 21, 3, 42).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQueryUtil.getValueInPixel(80)),
          topRight: Radius.circular(MediaQueryUtil.getValueInPixel(80)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(
            children: [
              Expanded(
                // Moved Expanded here
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0A2F4D).withOpacity(0.9),
                        const Color(0xFF1A1A2E).withOpacity(0.95),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 0.75,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
