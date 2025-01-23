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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(
                height: MediaQueryUtil.getDefaultHeightDim(384), // 15% of 2560
              ),
              _buildContent(context),
              const Spacer(),
              _buildButton(context),
              SizedBox(
                height: MediaQueryUtil.getDefaultHeightDim(128), // 5% of 2560
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQueryUtil.getPaddingTop(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQueryUtil.getDefaultWidthDim(144), // 10% of 1440
          ),
          Expanded(
            child: Center(
              child: Text(
                'StringConstants.homeTile',
                style: GoogleFonts.inter(
                  fontSize: MediaQueryUtil.getFontSize(115.2), // 8% of 1440
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQueryUtil.getDefaultWidthDim(144), // 10% of 1440
          ),
          const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'StringConstants.congrats',
          style: GoogleFonts.inter(
            fontSize: MediaQueryUtil.getFontSize(72), // 5% of 1440
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(51.2), // 2% of 2560
        ),
        Text(
          'StringConstants.msg',
          style: GoogleFonts.inter(
            fontSize: MediaQueryUtil.getFontSize(115.2), // 8% of 1440
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(51.2), // 2% of 2560
        ),
        Text(
          "\u{20B9} 1,25,000",
          style: GoogleFonts.inter(
            fontSize: MediaQueryUtil.getFontSize(115.2), // 8% of 1440
            fontWeight: FontWeight.w700,
            color: Colors.greenAccent,
          ),
        ),
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(51.2), // 2% of 2560
        ),
        Text(
          'StringConstants.subText',
          style: GoogleFonts.inter(
            fontSize: MediaQueryUtil.getFontSize(72), // 5% of 1440
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
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
