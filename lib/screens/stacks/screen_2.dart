import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:provider/provider.dart';
import '../../constants/strings_constants.dart';
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
  EMIPlanModel selectedEMIPlan = EMIPlanModel(
      label: 'RECOMMENDED',
      amount: '₹5,117',
      duration: '24 months'); // default EMI plan
  Screen2Provider provider = Screen2Provider();

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slideAnimation =
        Tween<double>(begin: 0.0, end: 0.9).animate(slideController);
    super.initState();
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
    return Stack(
      children: [
        ChangeNotifierProvider.value(
          value: provider,
          child: _stackPopupContent(),
        ),
      ],
    );
  }

  // Widget for the StackPopup content
  Widget _stackPopupContent() {
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
              return provider.getIsEmiClicked()
                  ? _stackPopupView()
                  : _originalView();
            }),
          ),
          Consumer<Screen2Provider>(builder: (context, provider, child) {
            return provider.getIsEmiClicked()
                ? StackPopup(
                    animCompleteCallback: _slideAnimCompleted,
                    animReversedCallBack: _slideAnimReversed,
                    slideController: slideController,
                    slideAnimation: slideAnimation,
                    screenNumber: 1,
                    child:
                        Screen3(handleBackButton: () {}, handleEMIPlan: () {}),
                  )
                : const SizedBox();
          }),
        ],
      ),
    );
  }

  // Widget for the StackPopup view
  Widget _stackPopupView() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: MediaQueryUtil.safeHeight,
        width: MediaQueryUtil.safeWidth,
        key: ValueKey(
            'stackPopupKey' "${StackPopupModel.getCurrentStackPopupIndex()}"),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQueryUtil.getValueInPixel(100)),
            topRight: Radius.circular(MediaQueryUtil.getValueInPixel(100)),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQueryUtil.getValueInPixel(80),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQueryUtil.getValueInPixel(100),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _selectedAmountWidget(),
                        SizedBox(
                          width: MediaQueryUtil.getDefaultWidthDim(500),
                        ),
                        _durationWidget(),
                      ],
                    )
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                _getDropDownIcon(),
                SizedBox(
                  width: MediaQueryUtil.getValueInPixel(70),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the original view before StackPopup
  Widget _originalView() {
    return GestureDetector(
      onTap: () {
        _reverseStackPopupAnim();
      },
      child: Column(
        key: ValueKey(
            'originalViewKey' "${StackPopupModel.getCurrentStackPopupIndex()}"),
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQueryUtil.getValueInPixel(150),
              ),
              _headerWidget()
            ],
          ),
          SizedBox(
            height: MediaQueryUtil.getDefaultHeightDim(100),
          ),
          EMIPlan(onEMIChange: onEMIPlanChange),
          SizedBox(
            height: MediaQueryUtil.getDefaultHeightDim(400),
          ),
          _getNeoPopButton(),
        ],
      ),
    );
  }

  // Widget for the header
  Widget _headerWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQueryUtil.getValueInPixel(100),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CommonWidgets.FontWidget(
                StringConstants.emiPlanHeader,
                Colors.white.withOpacity(0.8),
                FontWeight.w500,
                "Roboto",
                FontStyle.normal,
                80,
                TextAlign.left),
            SizedBox(
              width: MediaQueryUtil.getDefaultWidthDim(200),
            ),
            _getRateButton(),
          ],
        ),
        SizedBox(
          height: MediaQueryUtil.getValueInPixel(50),
        ),
        _getSubHeader(),
      ],
    );
  }

  // Widget for the rate button
  Widget _getRateButton() {
    return Container(
      width: MediaQueryUtil.getValueInPixel(350),
      height: MediaQueryUtil.getValueInPixel(100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Center(
          child: CommonWidgets.FontWidget(
              "@1.49% p.m",
              Colors.green,
              FontWeight.w700,
              "Roboto",
              FontStyle.normal,
              50,
              TextAlign.center)),
    );
  }

  // Widget for the subheader
  Widget _getSubHeader() {
    return CommonWidgets.FontWidget(
        StringConstants.oneRate,
        Colors.white.withOpacity(0.6),
        FontWeight.w400,
        "Roboto",
        FontStyle.normal,
        60,
        TextAlign.left);
  }

  // Widget for displaying selected EMI amount
  Widget _selectedAmountWidget() {
    List<Widget> li = [];
    li.add(CommonWidgets.FontWidget(
        StringConstants.emi,
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
  Widget _durationWidget() {
    List<Widget> li = [];
    li.add(CommonWidgets.FontWidget(
        StringConstants.duration,
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

  // Widget for displaying NeoPop button
  Widget _getNeoPopButton() {
    return NeoPopButton(
      color: Colors.white,
      onTapUp: () => HapticFeedback.vibrate(),
      onTapDown: () {
        // If already clicked then don't spam tap
        if (provider.getIsEmiClicked()) {
          return;
        }
        provider.setIsEmiClicked(true);
      },
      child: SizedBox(
        height: MediaQueryUtil.getValueInPixel(200),
        width: MediaQueryUtil.getValueInPixel(1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets.FontWidget(
                  StringConstants.chooseEMI,
                  Colors.black,
                  FontWeight.w600,
                  "Inter",
                  FontStyle.normal,
                  70,
                  TextAlign.left)
            ],
          ),
        ),
      ),
    );
  }
}
