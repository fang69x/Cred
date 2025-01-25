import 'package:cred/helperWidgets/curved_edge_button.dart';
import 'package:cred/models/api.model.dart';
import 'package:cred/models/stack_popup.dart';
import 'package:cred/providers/data.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/media_query.dart';
import 'package:flutter/material.dart' as material;

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
    slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
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
    return Consumer<CredDataProvider>(
        builder: (context, credDataProvider, child) {
      if (credDataProvider.isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (credDataProvider.error != null) {
        return Center(child: Text('Error : ${credDataProvider.error}'));
      }
      if (credDataProvider.credData == null ||
          credDataProvider.credData!.items.isEmpty) {
        return Center(child: Text('No data available'));
      }
      final thirdItem = credDataProvider.credData!.items[2];
      final claT = thirdItem.ctaText;
      final openState = thirdItem.openState!.body;

      return Stack(
        children: [
          Column(
            children: [
              originalView(openState!, claT!),
            ],
          ),
        ],
      );
    });
  }

  Widget originalView(OpenStateBody openState, String claT) {
    ValueNotifier<int?> selectedTileIndex = ValueNotifier<int?>(null);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          key: ValueKey('originalViewKey'
              "${StackPopupModel.getCurrentStackPopupIndex()}"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              openState.title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color:
                    const Color.fromARGB(255, 114, 148, 164), // Deep grey blue
              ),
            ),
            SizedBox(height: MediaQueryUtil.getValueInPixel(20)),

            // Subtitle
            Text(
              openState.subtitle,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color.fromARGB(141, 106, 117, 122), // Light grey
              ),
            ),
            SizedBox(height: MediaQueryUtil.getValueInPixel(20)),

            // Elevated ListTiles with Checkbox for selection
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height * 0.5, // Limit height
              ),
              child: ListView.builder(
                shrinkWrap:
                    true, // Ensure the ListView doesn't take infinite height
                physics:
                    NeverScrollableScrollPhysics(), // Disable scrolling here
                itemCount: openState.items.length, // Number of tiles
                itemBuilder: (context, index) {
                  final bank = openState.items[index];
                  final bankName = bank.title;
                  return ValueListenableBuilder<int?>(
                    valueListenable: selectedTileIndex,
                    builder: (context, selectedIndex, child) {
                      bool isSelected = selectedIndex == index;
                      return // Updated Card Widget
                          material.Card(
                        elevation: 4, // Reduced elevation for subtlety
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: const Color.fromARGB(115, 158, 116,
                            255), // Changed to white for better contrast
                        shadowColor:
                            Colors.grey.withOpacity(0.5), // Softer shadow
                        child: ListTile(
                          leading: Icon(
                            Icons.food_bank_outlined,
                            color: isSelected ? Colors.blueAccent : Colors.grey,
                          ),
                          title: Text(
                            bankName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.blueAccent : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            bank.subtitle.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blueAccent[700]
                                  : Colors.black54,
                            ),
                          ),
                          tileColor: isSelected
                              ? Colors.blueAccent.withOpacity(0.1)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              selectedTileIndex.value =
                                  value! ? index : null; // Toggle selection
                            },
                          ),
                          onTap: () {
                            selectedTileIndex.value =
                                isSelected ? null : index; // Toggle selection
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: MediaQueryUtil.getDefaultHeightDim(20)),

            // Footer Button
            GestureDetector(
              onTap: () {
                // Handle footer button tap if needed
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Button background color
                  borderRadius: BorderRadius.circular(16.0), // Rounded button
                ),
                child: Text(
                  openState.footer,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Curved Edge Button with callback
            CurvedEdgeButton(
              text: claT,
              onTap: () {
                // Add button logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  void reverseStackPopupAnim() {}
}
