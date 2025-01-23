import 'package:cred/helperWidgets/curved_edge_button.dart';
import 'package:cred/models/api.model.dart';
import 'package:cred/service/api.service.dart';
import 'package:cred/utils/common_widgets.dart';
import 'package:cred/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:provider/provider.dart';

import '../../constants/strings_constants.dart';
import '../../helperWidgets/circular_progress_bar.dart';
import '../../providers/screen_1_provider.dart';

import '../../models/loan_data.dart';
import '../../models/stack_popup.dart';
import 'screen_2.dart';
import 'stack_popup.dart';

class Screen1 extends StatefulWidget {
  final Function handleBackButton;
  final Function handleEMIPlan;

  const Screen1(
      {super.key, required this.handleBackButton, required this.handleEMIPlan});

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with TickerProviderStateMixin {
  late AnimationController slideController;
  late Animation<double> slideAnimation;
  Screen1Provider provider = Screen1Provider();
  late LoanData loanDataObj;
  late Future<CredModel> futureApiResponse;

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slideAnimation =
        Tween<double>(begin: 0.0, end: 0.78).animate(slideController);
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
    return FutureBuilder<CredModel>(
        future: futureApiResponse,
        builder: (BuildContext context, AsyncSnapshot<CredModel> snapshot) {
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
              return Center(child: Text('No data available'));
            }

            // Access API data directly
            final firstItem = snapshot.data!.items[0];
            final claT = firstItem.ctaText;
            final openState = firstItem.openState!.body;

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _hudElement(),

                    //

                    ChangeNotifierProvider.value(
                        value: provider,
                        child: _stackPopupContent(openState!, claT!)),
                  ],
                ),
                ChangeNotifierProvider.value(
                    value: provider, child: _openStackPopup()),
              ],
            );
          }
        });
  }

  Widget _stackPopupContent(OpenStateBody openState, String claT) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Consumer<Screen1Provider>(builder: (context, provider, child) {
            return provider.getIsEmiClicked()
                ? _stackPopupView(openState)
                : _originalView(openState, claT);
          }),
        ),
      ],
    );
  }

  Widget _openStackPopup() {
    return Consumer<Screen1Provider>(builder: (context, provider, child) {
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

  /// View when stack is open
  Widget _stackPopupView(OpenStateBody openState) {
    return GestureDetector(
      onTap: () {
        _reverseStackPopupAnim();
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: MediaQueryUtil.safeHeight * 0.8,
          width: MediaQueryUtil.safeWidth,
          key: ValueKey(
              'stackPopupKey' "${StackPopupModel.getCurrentStackPopupIndex()}"),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
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
                      ..._selectedAmountWidget(openState),
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
      ),
    );
  }

  /// Hud element like back button and FAQ
  Widget _hudElement() {
    return Column(
      children: [
        SizedBox(
          height: MediaQueryUtil.getPaddingTop() +
              MediaQueryUtil.getValueInPixel(100),
        ),
        Row(
          children: [
            SizedBox(width: MediaQueryUtil.getValueInPixel(100)),
            GestureDetector(
              onTap: () {
                widget.handleBackButton();
              },
              child: CommonWidgets.getBackButtonWidget(),
            ),
            const Expanded(child: SizedBox()),
            _getFAQIcon(),
            SizedBox(
              width: MediaQueryUtil.getValueInPixel(100),
            ),
          ],
        ),
        SizedBox(
          height: MediaQueryUtil.getValueInPixel(200),
        ),
      ],
    );
  }

  /// Widget when stack is not visisble
  Widget _originalView(OpenStateBody openState, String claT) {
    return GestureDetector(
      onTap: () {
        _reverseStackPopupAnim();
      },
      child: Column(
        key: ValueKey(
            'originalViewKey${StackPopupModel.getCurrentStackPopupIndex()}'),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title and Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  openState.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  openState.subtitle,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 117, 117, 117),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: _selectBankWidget(),
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    openState.card!.header,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    openState.card!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressBar(
                    radius: 100,
                    strokeWidth: 10,
                    progressColor: Colors.greenAccent,
                    arrowColor: Colors.white,
                    progress: 0.5,
                    startValue: 100000,
                    endValue: 150000,
                    onChanged: (double progress, int finalValue) {
                      loanDataObj.setLoanAmout(finalValue);
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    openState.footer,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 150),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: CurvedEdgeButton(
              text: claT,
              onTap: () {
                if (provider.getIsEmiClicked()) {
                  return;
                }
                provider.setIsEmiClicked(true);
                widget.handleEMIPlan();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Helpers widget

  Widget _selectBankWidget() {
    return CommonWidgets.FontWidget(
        StringConstants.anyAmount,
        Colors.white.withOpacity(0.6),
        FontWeight.w500,
        "Roboto",
        FontStyle.normal,
        60,
        TextAlign.left);
  }

  List<Widget> _selectedAmountWidget(OpenStateBody openState) {
    List<Widget> li = [];
    li.add(CommonWidgets.FontWidget(
        openState.card!.header.toString(),
        Colors.white.withOpacity(0.5),
        FontWeight.w400,
        "Roboto",
        FontStyle.normal,
        60,
        TextAlign.left));
    // li.add(CommonWidgets.FontWidget(NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 0).format(loanDataObj.getLoanAmount()), Colors.white.withOpacity(0.6), FontWeight.w400, "Roboto", FontStyle.normal, 60, TextAlign.center));

    return li;
  }

  Widget _getFAQIcon() {
    return const Icon(
      Icons.add_comment_outlined,
      color: Colors.white,
    );
  }

  Widget _getDropDownIcon() {
    return const Icon(
      Icons.arrow_downward,
      color: Colors.white,
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
