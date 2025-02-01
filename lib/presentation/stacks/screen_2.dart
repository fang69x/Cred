import 'dart:ui';
import 'package:cred/data/models/api.model.dart';
import 'package:cred/presentation/providers/api_data_provider.dart';
import 'package:cred/presentation/providers/screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cred/presentation/widgets/curved_edge_button.dart';
import 'package:cred/presentation/widgets/emi_plan_widget.dart';
import 'package:cred/presentation/widgets/collapsed_glass_panel.dart';
import '../../data/models/emi_plan_model.dart';
import '../../data/models/stack_popup.dart';
import '../../core/constants/media_query.dart';
import 'screen_3.dart';
import 'stack_popup.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with TickerProviderStateMixin {
  late AnimationController slideController;
  late Animation<double> slideAnimation;
  EMIPlanModel selectedEMIPlan = EMIPlanModel(
      label: 'RECOMMENDED', amount: '₹5,580', duration: '9 months');
  late ScreenProvider provider;

  @override
  void initState() {
    super.initState();
    StackPopupModel.incCurrentStackPopupIndex();
    _initializeAnimations();
    provider = ScreenProvider();
  }

  void _initializeAnimations() {
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    slideAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
        CurvedAnimation(parent: slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    slideController.dispose();
    StackPopupModel.decCurrentStackPopupIndex();
    super.dispose();
  }

  void onEMIPlanChange(EMIPlanModel emi) =>
      setState(() => selectedEMIPlan = emi);
  void _slideAnimCompleted() {}
  void _slideAnimReversed() => provider.setIsEmiClicked(false);
  void _reverseStackPopupAnim() {
    if (provider.getIsEmiClicked()) slideController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Consumer<CredDataProvider>(
      builder: (context, credDataProvider, child) {
        if (credDataProvider.isLoading) {
          return _buildLoadingState();
        }
        if (credDataProvider.error != null) {
          return _buildErrorState(credDataProvider.error!);
        }
        if (credDataProvider.credData == null ||
            credDataProvider.credData!.items.isEmpty) {
          return _buildEmptyState();
        }

        final secondItem = credDataProvider.credData!.items[1];
        final openState = secondItem.openState!.body;
        final closedState = secondItem.closedState!.body;
        final ctaText = secondItem.ctaText;

        return Container(
          decoration: _buildGradientDecoration(),
          child: Stack(
            children: [
              _buildBackgroundElements(),
              Column(
                children: [
                  ChangeNotifierProvider.value(
                    value: provider,
                    child:
                        _buildMainContent(openState!, ctaText!, closedState!),
                  ),
                ],
              ),
              ChangeNotifierProvider.value(
                value: provider,
                child: _buildStackPopup(closedState),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              color: Colors.white.withOpacity(0.8),
              size: MediaQueryUtil.getValueInPixel(40)),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(16)),
          Text(
            'Failed to load data',
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.9),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(8)),
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
              color: Colors.white.withOpacity(0.8),
              size: MediaQueryUtil.getValueInPixel(40)),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(16)),
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

  BoxDecoration _buildGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0A2F4D),
          const Color(0xFF1A1A2E).withOpacity(0.9),
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

  Widget _buildMainContent(
      OpenStateBody openState, String ctaText, ClosedStateBody closedState) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Consumer<ScreenProvider>(
            builder: (context, provider, child) {
              return provider.getIsEmiClicked()
                  ? _buildStackPopupView(closedState)
                  : _buildOriginalView(openState, ctaText);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStackPopupView(ClosedStateBody closedState) {
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: FrostedGlassPanel(
        height: MediaQueryUtil.safeHeight,
        child: Column(
          children: [
            Padding(
              padding: MediaQueryUtil.getResponsivePadding(
                  horizontal: 100, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSelectedAmountWidget(closedState),
                  _buildDurationWidget(closedState),
                  _buildControlIcons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalView(OpenStateBody openState, String ctaText) {
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQueryUtil.getResponsivePadding(
                horizontal: 40, vertical: 20),
            child: Column(
              key: ValueKey(
                  'originalViewKey${StackPopupModel.getCurrentStackPopupIndex()}'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(openState),
                SizedBox(height: MediaQueryUtil.getDefaultHeightDim(20)),
                _buildEMIPlanSection(openState),
                SizedBox(height: MediaQueryUtil.getDefaultHeightDim(30)),
                _buildActionButton(ctaText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(OpenStateBody openState) {
    return Padding(
      padding:
          MediaQueryUtil.getResponsivePadding(horizontal: 60, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            openState.title,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: MediaQueryUtil.getFontSize(100),
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(12)),
          Text(
            openState.subtitle,
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.8),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEMIPlanSection(OpenStateBody openState) {
    return EMIPlan(
      onEMIChange: onEMIPlanChange,
      emiPlanItems: openState.items,
      footer: openState.footer,
    );
  }

  Widget _buildActionButton(String ctaText) {
    return Padding(
      padding: MediaQueryUtil.getResponsivePadding(horizontal: 40, vertical: 0),
      child: CurvedEdgeButton(
        width: double.infinity,
        text: ctaText,
        onTap: () {
          if (provider.getIsEmiClicked()) return;
          provider.setIsEmiClicked(true);
        },
      ),
    );
  }

  Widget _buildSelectedAmountWidget(ClosedStateBody closedState) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQueryUtil.getDefaultHeightDim(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            closedState.key1!,
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.8),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w400,
            ),
          ),
          _buildGradientText(selectedEMIPlan.amount, 100,
              const [Color(0xFF947D4E), Color.fromARGB(212, 253, 182, 49)]),
        ],
      ),
    );
  }

  Widget _buildDurationWidget(ClosedStateBody closedState) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQueryUtil.getDefaultHeightDim(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            closedState.key2!,
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.8),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w400,
            ),
          ),
          _buildGradientText(selectedEMIPlan.duration, 100,
              [Color.fromARGB(212, 253, 182, 49), const Color(0xFF947D4E)]),
        ],
      ),
    );
  }

  Widget _buildGradientText(String text, double fontSize, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: MediaQueryUtil.getFontSize(fontSize),
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildControlIcons() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withOpacity(0.8),
            size: MediaQueryUtil.getValueInPixel(24),
          ),
          onPressed: _reverseStackPopupAnim,
        ),
      ],
    );
  }

  Widget _buildStackPopup(ClosedStateBody closedState) {
    return Consumer<ScreenProvider>(
      builder: (context, provider, child) {
        return provider.getIsEmiClicked()
            ? StackPopup(
                animCompleteCallback: _slideAnimCompleted,
                animReversedCallBack: _slideAnimReversed,
                slideController: slideController,
                slideAnimation: slideAnimation,
                screenNumber: 2,
                child: Screen3(
                  handleBackButton: () => Navigator.pop(context),
                  handleEMIPlan: () {},
                ),
              )
            : SizedBox(height: MediaQueryUtil.getDefaultHeightDim(2));
      },
    );
  }
}
