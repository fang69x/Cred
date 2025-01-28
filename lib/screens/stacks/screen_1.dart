import 'dart:ui';
import 'package:cred/helperWidgets/circular_progress_bar.dart';
import 'package:cred/helperWidgets/curved_edge_button.dart';
import 'package:cred/helperWidgets/glass_panel.dart';
import 'package:cred/models/api.model.dart';
import 'package:cred/providers/data.provider.dart';
import 'package:cred/service/api.service.dart';
import 'package:cred/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/screen_provider.dart';
import '../../models/loan_data.dart';
import '../../models/stack_popup.dart';
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

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0A2F4D),
                const Color(0xFF1A1A2E).withOpacity(0.9),
              ],
            ),
          ),
          child: Stack(
            children: [
              _buildBackgroundElements(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hudElement(),
                  ChangeNotifierProvider.value(
                    value: provider,
                    child: _stackPopupContent(openState!, claT!),
                  ),
                ],
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
          const SizedBox(height: 16),
          Text(
            'Failed to load data',
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
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
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Positioned.fill(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueAccent.withOpacity(0.1),
                    Colors.purpleAccent.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stackPopupContent(OpenStateBody openState, String claT) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Consumer<ScreenProvider>(builder: (context, provider, child) {
            return provider.getIsEmiClicked()
                ? _stackPopupView(openState)
                : _originalView(openState, claT);
          }),
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
          : const SizedBox();
    });
  }

  Widget _stackPopupView(OpenStateBody openState) {
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: Align(
        alignment: Alignment.centerRight,
        child: FrostedGlassPanel(
          height: MediaQueryUtil.safeHeight * 0.8,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoanAmountDisplay(),
                    _buildControlIcons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hudElement() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQueryUtil.getPaddingTop() + 24,
        left: 24,
        right: 24,
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
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          key: ValueKey(
              'originalViewKey${StackPopupModel.getCurrentStackPopupIndex()}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(openState),
            const SizedBox(height: 40),
            _buildCreditCardWidget(openState),
            const SizedBox(height: 40),
            _buildActionButton(claT),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(OpenStateBody openState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          openState.title,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          openState.subtitle,
          style: GoogleFonts.roboto(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w400,
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
      onChanged: (double progress, int finalValue) {
        loanDataObj.setLoanAmount(finalValue);
      },
    );
  }

  Widget _buildActionButton(String claT) {
    return CurvedEdgeButton(
      width: double.infinity,
      text: claT,
      onTap: () {
        if (provider.getIsEmiClicked()) return;
        provider.setIsEmiClicked(true);
      },
    );
  }

  Widget _buildLoanAmountDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Amount',
          style: GoogleFonts.roboto(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ).createShader(bounds),
          child: Text(
            NumberFormat.currency(
                    locale: 'en_IN', symbol: '₹ ', decimalDigits: 0)
                .format(loanDataObj.getLoanAmount()),
            style: GoogleFonts.roboto(
              fontSize: 36,
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
