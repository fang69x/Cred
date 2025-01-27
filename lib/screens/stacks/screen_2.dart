import 'dart:ui';

import 'package:cred/helperWidgets/curved_edge_button.dart';
import 'package:cred/models/api.model.dart';
import 'package:cred/providers/data.provider.dart';
import 'package:cred/service/api.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../helperWidgets/emi_plan.dart';
import '../../models/emi_plan_model.dart';
import '../../models/stack_popup.dart';
import '../../providers/screen_2_provider.dart';
import '../../utils/common_widgets.dart';
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
      label: 'RECOMMENDED',
      amount: '₹5,580',
      duration: '9 months'); // default EMI plan
  Screen2Provider provider = Screen2Provider();

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    slideAnimation =
        Tween<double>(begin: 0.0, end: 0.9).animate(slideController);
    super.initState();
    futureApiResponse = Apiservice.fetchData();
  }

  @override
  void dispose() {
    slideController.dispose();
    StackPopupModel.decCurrentStackPopupIndex();
    super.dispose();
  }

  void onEMIPlanChange(EMIPlanModel emi) {
    selectedEMIPlan = emi;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CredDataProvider>(
      builder: (context, credDataProvider, child) {
        if (credDataProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (credDataProvider.error != null) {
          return Center(child: Text('Error: ${credDataProvider.error}'));
        }

        if (credDataProvider.credData == null ||
            credDataProvider.credData!.items.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final secondItem = credDataProvider.credData!.items[1];

        final claT = secondItem.ctaText;
        final openState = secondItem.openState!.body;
        final closedState = secondItem.closedState!.body;
        return Stack(
          children: [
            ChangeNotifierProvider.value(
              value: provider,
              child: _stackPopupContent(openState!, claT!, closedState!),
            ),
          ],
        );
      },
    );
  }

  Widget _stackPopupContent(
      OpenStateBody openState, String claT, ClosedStateBody closedState) {
    return GestureDetector(
      onTap: () {
        _reverseStackPopupAnim();
      },
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                Consumer<Screen2Provider>(builder: (context, provider, child) {
              if (provider.getIsEmiClicked()) {
                return _stackPopupView(closedState);
              } else {
                return _originalView(openState, claT);
              }
            }),
          ),
          Consumer<Screen2Provider>(builder: (context, provider, child) {
            if (provider.getIsEmiClicked()) {
              return StackPopup(
                animCompleteCallback: _slideAnimCompleted,
                animReversedCallBack: _slideAnimReversed,
                slideController: slideController,
                slideAnimation: slideAnimation,
                screenNumber: 1,
                child: Screen3(handleBackButton: () {}, handleEMIPlan: () {}),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _stackPopupView(ClosedStateBody closedState) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQueryUtil.safeWidth,
        key: ValueKey(
            'stackPopupKey' "${StackPopupModel.getCurrentStackPopupIndex()}"),
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              131, 10, 45, 74), // Match the previous color scheme
          border: Border.all(color: Colors.white, width: 0.5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQueryUtil.getValueInPixel(100)),
            topRight: Radius.circular(MediaQueryUtil.getValueInPixel(100)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4), // Shadow with opacity
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Apply the blur effect using ImageFilter from dart:ui
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 1.0), // Adjust blur intensity
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.black.withOpacity(0), // Transparent background
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQueryUtil.getValueInPixel(80),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQueryUtil.getValueInPixel(50),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _selectedAmountWidget(closedState),
                            SizedBox(
                              width: MediaQueryUtil.getDefaultWidthDim(500),
                            ),
                            _durationWidget(closedState),
                          ],
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    _getDropDownIcon(),
                    SizedBox(
                      width: MediaQueryUtil.getValueInPixel(70),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _originalView(OpenStateBody openState, String claT) {
    return GestureDetector(
      onTap: () {
        _reverseStackPopupAnim();
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 20.0, // Added vertical padding for better spacing
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQueryUtil.getValueInPixel(80)),
              Text(
                openState.title,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 114, 148, 164),
                ),
              ),
              SizedBox(height: MediaQueryUtil.getDefaultHeightDim(12)),
              Text(
                openState.subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 55, 71, 79),
                ),
              ),
              SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
              EMIPlan(
                onEMIChange: onEMIPlanChange,
                emiPlanItems: openState.items,
                footer: openState.footer,
              ),
              SizedBox(height: MediaQueryUtil.getDefaultHeightDim(550)),
              CurvedEdgeButton(
                onTap: () {
                  if (provider.getIsEmiClicked()) {
                    return;
                  }
                  provider.setIsEmiClicked(true);
                },
                text: claT,
                width: double.infinity,
                textColor: Colors.white,
              ),
            ],
          )),
    );
  }

  Widget _selectedAmountWidget(ClosedStateBody closedState) {
    List<Widget> li = [];
    li.add(CommonWidgets.FontWidget(
        closedState.key1!,
        Colors.white.withOpacity(0.5),
        FontWeight.w400,
        "Inter",
        FontStyle.normal,
        60,
        TextAlign.left));
    li.add(CommonWidgets.FontWidget(
        selectedEMIPlan.amount,
        Colors.white.withOpacity(0.7),
        FontWeight.w500,
        "Inter",
        FontStyle.normal,
        70,
        TextAlign.left));

    return Column(
      children: [...li],
    );
  }

  // Widget for displaying EMI duration
  Widget _durationWidget(ClosedStateBody closedState) {
    List<Widget> li = [];
    li.add(CommonWidgets.FontWidget(
        closedState.key2!,
        Colors.white.withOpacity(0.5),
        FontWeight.w400,
        "Inter",
        FontStyle.normal,
        60,
        TextAlign.left));
    li.add(CommonWidgets.FontWidget(
        selectedEMIPlan.duration,
        Colors.white.withOpacity(0.7),
        FontWeight.w500,
        "Inter",
        FontStyle.normal,
        70,
        TextAlign.left));

    return Column(
      children: [...li],
    );
  }

  // Widget for displaying dropdown icon
  Widget _getDropDownIcon() {
    return const Icon(
      Icons.arrow_downward,
      color: Colors.white,
    );
  }

  void reverseStackPopupAnim() {}
}
