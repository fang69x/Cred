import 'package:cred/utils/media_query.dart';
import 'package:cred/utils/screen_trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Initialize MediaQueryUtil
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.getDefaultWidthDim(216), // 15% of 1440
          ),
          child: _buildButton(context),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Center(
      child: NeoPopButton(
        color: Colors.white,
        onTapUp: () => HapticFeedback.vibrate(),
        onTapDown: () => Navigator.push(context, ScreenTrans.introScreen()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          child: Text(
            'Tap to start',
            style: GoogleFonts.inter(
              fontSize: MediaQueryUtil.getFontSize(100.8), // 7% of 1440
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
