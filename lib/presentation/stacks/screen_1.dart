import 'dart:ui';
import 'package:cred/presentation/widgets/credit_card_widget.dart';
import 'package:cred/presentation/widgets/curved_edge_button.dart';
import 'package:cred/presentation/widgets/collapsed_glass_panel.dart';
import 'package:cred/data/models/api.model.dart';
import 'package:cred/presentation/providers/api_data_provider.dart';
import 'package:cred/data/service/api_service.dart';
import 'package:cred/core/constants/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/screen_provider.dart';
import '../../data/models/loan_data.dart';
import '../../data/models/stack_popup.dart';
import 'screen_2.dart';
import 'stack_popup.dart';

class Screen1 extends StatefulWidget {
  final Function handleBackButton;

  const Screen1({super.key, required this.handleBackButton});

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with TickerProviderStateMixin {
  late AnimationController slideController;
  late Animation<double> slideAnimation;
  ScreenProvider provider = ScreenProvider();
  late LoanData loanDataObj;
  late Future<CredModel> futureApiResponse;

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    slideAnimation = Tween<double>(begin: 0.0, end: 0.78).animate(
        CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic));
    loanDataObj = LoanData();
    super.initState();
    futureApiResponse = Apiservice.fetchData();
  }

  @override
  void dispose() {
    slideController.dispose();
    StackPopupModel.decCurrentStackPopupIndex();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Consumer<CredDataProvider>(
      builder: (context, credDataProvider, child) {
        if (credDataProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
            ),
          );
        }

        if (credDataProvider.error != null) {
          return _buildErrorState(credDataProvider.error!);
        }

        if (credDataProvider.credData == null ||
            credDataProvider.credData!.items.isEmpty) {
          return _buildEmptyState();
        }

        final firstItem = credDataProvider.credData!.items[0];
        final claT = firstItem.ctaText;
        final openState = firstItem.openState!.body;
        final closedState = firstItem.closedState!.body;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F3460),
                Color(0xFF16213E),
                Color(0xFF1A1A2E),
              ],
              stops: [0.1, 0.5, 0.9],
            ),
          ),
          child: Stack(
            children: [
              _buildAnimatedBackground(),
              Positioned.fill(
                child: Column(
                  children: [
                    _hudElement(),
                    Expanded(
                      child: ChangeNotifierProvider.value(
                        value: provider,
                        child:
                            _stackPopupContent(openState!, claT!, closedState!),
                      ),
                    ),
                  ],
                ),
              ),
              ChangeNotifierProvider.value(
                value: provider,
                child: _openStackPopup(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              color: Colors.white.withOpacity(0.8), size: 40),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(40)),
          Text(
            'Failed to load data',
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.9),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(40)),
          Text(
            error,
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.7),
              fontSize: MediaQueryUtil.getFontSize(50),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty,
              color: Colors.white.withOpacity(0.8), size: 40),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(40)),
          Text(
            'No data available',
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.9),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F3460).withOpacity(0.8),
            Color(0xFF16213E).withOpacity(0.6),
            Color(0xFF1A1A2E).withOpacity(0.4),
          ],
        ),
      ),
    );
  }

  Widget _stackPopupContent(
      OpenStateBody openState, String claT, ClosedStateBody closedState) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Consumer<ScreenProvider>(
            builder: (context, provider, child) {
              return provider.getIsEmiClicked()
                  ? _stackPopupView(openState, closedState)
                  : _originalView(openState, claT);
            },
          ),
        ),
      ],
    );
  }

  Widget _openStackPopup() {
    return Consumer<ScreenProvider>(builder: (context, provider, child) {
      return provider.getIsEmiClicked()
          ? StackPopup(
              animCompleteCallback: _slideAnimCompleted,
              animReversedCallBack: _slideAnimReversed,
              slideController: slideController,
              slideAnimation: slideAnimation,
              screenNumber: 1,
              child: const Screen2(),
            )
          : SizedBox(height: MediaQueryUtil.getDefaultHeightDim(40));
    });
  }

  Widget _stackPopupView(OpenStateBody openState, ClosedStateBody closedState) {
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: Column(
        children: [
          Expanded(
            child: FrostedGlassPanel(
              height: MediaQueryUtil.safeHeight * 0.9,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.getDefaultWidthDim(100),
                      vertical: MediaQueryUtil.getDefaultHeightDim(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLoanAmountDisplay(closedState),
                        _buildControlIcons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hudElement() {
    return Padding(
      padding: MediaQueryUtil.getResponsivePadding(
        horizontal: 24,
        vertical: 24,
      ).copyWith(
        top: MediaQueryUtil.getPaddingTop() +
            MediaQueryUtil.getDefaultHeightDim(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => widget.handleBackButton(),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _originalView(OpenStateBody openState, String claT) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(MediaQueryUtil.getValueInPixel(50)),
            child: _buildHeaderSection(openState),
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
          Expanded(child: _buildCreditCardWidget(openState)),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(100)),
          _buildActionButton(claT),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(100)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(OpenStateBody openState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Text(
            openState.title,
            key: ValueKey(openState.title),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: MediaQueryUtil.getFontSize(80),
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(100)),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: 1,
          child: Text(
            openState.subtitle,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditCardWidget(OpenStateBody openState) {
    return CreditCardWidget(
      minRange: openState.card!.minRange.toDouble(),
      maxRange: openState.card!.maxRange.toDouble(),
      header: openState.card!.header,
      footer: openState.footer,
      description: openState.card!.description,
      cardHeight: MediaQueryUtil.getDefaultHeightDim(600),
      onChanged: (double progress, int finalValue) {
        loanDataObj.setLoanAmount(finalValue);
      },
    );
  }

  Widget _buildActionButton(String claT) {
    return Padding(
      padding: MediaQueryUtil.getResponsivePadding(horizontal: 30),
      child: CurvedEdgeButton(
        width: MediaQueryUtil.getDefaultWidthDim(double.infinity),
        height: MediaQueryUtil.getDefaultHeightDim(200),
        text: claT,
        onTap: () {
          if (provider.getIsEmiClicked()) return;
          provider.setIsEmiClicked(true);
        },
      ),
    );
  }

  Widget _buildLoanAmountDisplay(ClosedStateBody closedState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          closedState.key1!,
          style: GoogleFonts.roboto(
            color: Colors.white.withOpacity(0.8),
            fontSize: MediaQueryUtil.getFontSize(50),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(2)),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFF947D4E),
              Color.fromARGB(212, 253, 182, 49)
            ],
          ).createShader(bounds),
          child: Text(
            NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹ ', decimalDigits: 0)
                .format(loanDataObj.getLoanAmount()),
            style: GoogleFonts.roboto(
              fontSize: MediaQueryUtil.getFontSize(100),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlIcons() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withOpacity(0.8)),
          onPressed: _reverseStackPopupAnim,
        ),
      ],
    );
  }

  void _slideAnimCompleted() {}

  void _slideAnimReversed() {
    provider.setIsEmiClicked(false);
  }

  void _reverseStackPopupAnim() {
    if (provider.getIsEmiClicked()) {
      slideController.reverse();
    }
  }
}
