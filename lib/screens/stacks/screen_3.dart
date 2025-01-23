import 'package:cred/models/stack_popup.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../../constants/strings_constants.dart';
import '../../utils/common_widgets.dart';
import '../../utils/media_query.dart';

class Screen3 extends StatefulWidget {
  final Function handleBackButton;
  final Function handleEMIPlan;

  const Screen3(
      {Key? key, required this.handleBackButton, required this.handleEMIPlan})
      : super(key: key);

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> with TickerProviderStateMixin {
  late AnimationController slideController;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slideAnimation =
        Tween<double>(begin: 0.0, end: 0.6).animate(slideController);
    super.initState();
  }

  @override
  void dispose() {
    slideController.dispose();
    StackPopupModel.decCurrentStackPopupIndex();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            originalView(),
          ],
        ),
      ],
    );
  }

  Widget originalView() {
    return Column(
      key: ValueKey(
          'originalViewKey' "${StackPopupModel.getCurrentStackPopupIndex()}"),
      children: [
        SizedBox(
          height: MediaQueryUtil.getValueInPixel(100),
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQueryUtil.getValueInPixel(100),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectYourBank(),
                SizedBox(
                  height: MediaQueryUtil.getValueInPixel(50),
                ),
                selectBankSubtextWidget(),
              ],
            )
          ],
        ),
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(300),
        ),
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(700),
        ),
        getNeoPopButton(),
      ],
    );
  }

  Widget selectYourBank() {
    return CommonWidgets.FontWidget(
        StringConstants.selectYourBank,
        Colors.white,
        FontWeight.w500,
        "Roboto",
        FontStyle.normal,
        80,
        TextAlign.left);
  }

  Widget selectBankSubtextWidget() {
    return CommonWidgets.FontWidget(
        StringConstants.selectBankSubtext,
        Colors.white.withOpacity(0.6),
        FontWeight.w400,
        "Roboto",
        FontStyle.normal,
        50,
        TextAlign.left);
  }

  void reverseStackPopupAnim() {}

  Widget getNeoPopButton() {
    return NeoPopButton(
      color: Colors.white,
      onTapUp: () => HapticFeedback.vibrate(),
      onTapDown: () {
        HapticFeedback.vibrate();
        // Fluttertoast.showToast(msg: "End of Flow", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
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
                  StringConstants.tapForInstantKYC,
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
