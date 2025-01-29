import 'dart:ui';
import 'package:cred/helperWidgets/curved_edge_button.dart';
import 'package:cred/helperWidgets/emi_plan.dart';
import 'package:cred/helperWidgets/glass_panel.dart';
import 'package:cred/models/api.model.dart';
import 'package:cred/providers/data.provider.dart';
import 'package:cred/providers/screen_provider.dart';
import 'package:cred/service/api.service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/emi_plan_model.dart';
import '../../models/stack_popup.dart';
import '../../utils/media_query.dart';
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
  late Future<CredModel> futureApiResponse;
  EMIPlanModel selectedEMIPlan = EMIPlanModel(
      label: 'RECOMMENDED', amount: '₹5,580', duration: '9 months');
  ScreenProvider provider = ScreenProvider();

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    slideAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
        CurvedAnimation(parent: slideController, curve: Curves.easeOut));
    super.initState();
    futureApiResponse = Apiservice.fetchData();
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

        final secondItem = credDataProvider.credData!.items[1];
        final claT = secondItem.ctaText;
        final openState = secondItem.openState!.body;
        final closedState = secondItem.closedState!.body;

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
                children: [
                  ChangeNotifierProvider.value(
                    value: provider,
                    child: _stackPopupContent(openState!, claT!, closedState!),
                  ),
                ],
              ),
              ChangeNotifierProvider.value(
                value: provider,
                child: _openStackPopup(closedState),
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

  Widget _stackPopupContent(
      OpenStateBody openState, String claT, ClosedStateBody closedState) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Consumer<ScreenProvider>(builder: (context, provider, child) {
            return provider.getIsEmiClicked()
                ? _stackPopupView(closedState)
                : _originalView(openState, claT);
          }),
        ),
      ],
    );
  }

  Widget _openStackPopup(ClosedStateBody closedState) {
    return Consumer<ScreenProvider>(builder: (context, provider, child) {
      return provider.getIsEmiClicked()
          ? StackPopup(
              animCompleteCallback: _slideAnimCompleted,
              animReversedCallBack: _slideAnimReversed,
              slideController: slideController,
              slideAnimation: slideAnimation,
              screenNumber: 2,
              child: Screen3(
                  handleBackButton: () {
                    Navigator.pop(context);
                  },
                  handleEMIPlan: () {}),
            )
          : const SizedBox();
    });
  }

  Widget _stackPopupView(ClosedStateBody closedState) {
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: FrostedGlassPanel(
        height: MediaQueryUtil.safeHeight,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _selectedAmountWidget(closedState),
                  _durationWidget(closedState),
                  _buildControlIcons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _originalView(OpenStateBody openState, String claT) {
    return GestureDetector(
      onTap: _reverseStackPopupAnim,
      child: SafeArea(
        child: Column(
          key: ValueKey(
              'originalViewKey${StackPopupModel.getCurrentStackPopupIndex()}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildHeaderSection(openState),
            ),
            const SizedBox(height: 40),
            EMIPlan(
              onEMIChange: onEMIPlanChange,
              emiPlanItems: openState.items,
              footer: openState.footer,
            ),
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

  Widget _selectedAmountWidget(ClosedStateBody closedState) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            closedState.key1!,
            style: GoogleFonts.roboto(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                const Color(0xFF947D4E),
                Color.fromARGB(212, 253, 182, 49)
              ],
            ).createShader(bounds),
            child: Text(
              selectedEMIPlan.amount,
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationWidget(ClosedStateBody closedState) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            closedState.key2!,
            style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color.fromARGB(212, 253, 182, 49),
                const Color(0xFF947D4E)
              ],
            ).createShader(bounds),
            child: Text(
              selectedEMIPlan.duration,
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
}
