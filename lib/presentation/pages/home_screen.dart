import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';
import 'package:cred/core/constants/media_query.dart';
import 'package:cred/core/utils/helper/screen_trans.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation =
        _createAnimation(begin: 0.5, end: 1.0, curve: Curves.elasticOut);
    _opacityAnimation = _createAnimation(
        begin: 0.0, end: 1.0, curve: Curves.easeIn, interval: 0.5);

    _animationController.forward();
  }

  Animation<double> _createAnimation({
    required double begin,
    required double end,
    required Curve curve,
    double interval = 1.0,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, interval, curve: curve),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.mediumImpact();
    await _animationController.reverse();
    if (mounted) {
      Navigator.push(context, ScreenTrans.introScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xCC000000), Color(0x99000000)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
            child: _buildContent(size),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Size size) {
    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _buildButton(size),
        ),
      ),
    );
  }

  Widget _buildButton(Size size) {
    return NeoPopButton(
      color: Colors.white,
      depth: 10,
      onTapUp: _handleTap,
      onTapDown: () => HapticFeedback.lightImpact(),
      child: Container(
        width: size.width * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Center(
          child: Text(
            'TAP TO START',
            style: GoogleFonts.inter(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
