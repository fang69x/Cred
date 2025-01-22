// class StackItem {
//   StackItem({
//     required this.items,
//   });

//   final List<StackItemItem> items;

//   factory StackItem.fromJson(Map<String, dynamic> json) {
//     return StackItem(
//       items: json["items"] == null
//           ? []
//           : List<StackItemItem>.from(
//               json["items"]!.map((x) => StackItemItem.fromJson(x))),
//     );
//   }
// }

// class StackItemItem {
//   StackItemItem({
//     required this.openState,
//     required this.closedState,
//     required this.ctaText,
//   });

//   final OpenState? openState;
//   final ClosedState? closedState;
//   final String? ctaText;

//   factory StackItemItem.fromJson(Map<String, dynamic> json) {
//     return StackItemItem(
//       openState: json["open_state"] == null
//           ? null
//           : OpenState.fromJson(json["open_state"]),
//       closedState: json["closed_state"] == null
//           ? null
//           : ClosedState.fromJson(json["closed_state"]),
//       ctaText: json["cta_text"],
//     );
//   }
// }

// class ClosedState {
//   ClosedState({
//     required this.body,
//   });

//   final ClosedStateBody? body;

//   factory ClosedState.fromJson(Map<String, dynamic> json) {
//     return ClosedState(
//       body:
//           json["body"] == null ? null : ClosedStateBody.fromJson(json["body"]),
//     );
//   }
// }

// class ClosedStateBody {
//   ClosedStateBody({
//     required this.key1,
//     required this.key2,
//   });

//   final String? key1;
//   final String? key2;

//   factory ClosedStateBody.fromJson(Map<String, dynamic> json) {
//     return ClosedStateBody(
//       key1: json["key1"],
//       key2: json["key2"],
//     );
//   }
// }

// class OpenState {
//   OpenState({
//     required this.body,
//   });

//   final OpenStateBody? body;

//   factory OpenState.fromJson(Map<String, dynamic> json) {
//     return OpenState(
//       body: json["body"] == null ? null : OpenStateBody.fromJson(json["body"]),
//     );
//   }
// }

// class OpenStateBody {
//   OpenStateBody({
//     required this.title,
//     required this.subtitle,
//     required this.card,
//     required this.footer,
//     required this.items,
//   });

//   final String? title;
//   final String? subtitle;
//   final Card? card;
//   final String? footer;
//   final List<BodyItem> items;

//   factory OpenStateBody.fromJson(Map<String, dynamic> json) {
//     return OpenStateBody(
//       title: json["title"],
//       subtitle: json["subtitle"],
//       card: json["card"] == null ? null : Card.fromJson(json["card"]),
//       footer: json["footer"],
//       items: json["items"] == null
//           ? []
//           : List<BodyItem>.from(
//               json["items"]!.map((x) => BodyItem.fromJson(x))),
//     );
//   }
// }

// class Card {
//   Card({
//     required this.header,
//     required this.description,
//     required this.maxRange,
//     required this.minRange,
//   });

//   final String? header;
//   final String? description;
//   final int? maxRange;
//   final int? minRange;

//   factory Card.fromJson(Map<String, dynamic> json) {
//     return Card(
//       header: json["header"],
//       description: json["description"],
//       maxRange: json["max_range"],
//       minRange: json["min_range"],
//     );
//   }
// }

// class BodyItem {
//   BodyItem({
//     required this.emi,
//     required this.duration,
//     required this.title,
//     required this.subtitle,
//     required this.tag,
//     required this.icon,
//   });

//   final String? emi;
//   final String? duration;
//   final String? title;
//   final dynamic? subtitle;
//   final String? tag;
//   final String? icon;

//   factory BodyItem.fromJson(Map<String, dynamic> json) {
//     return BodyItem(
//       emi: json["emi"],
//       duration: json["duration"],
//       title: json["title"],
//       subtitle: json["subtitle"],
//       tag: json["tag"],
//       icon: json["icon"],
//     );
//   }
// }

class StackItem {
  final String name;
  bool isExpanded;

  StackItem({required this.name, this.isExpanded = false});
}
