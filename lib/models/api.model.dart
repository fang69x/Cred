class ApiResponse {
  final List<Item> items;

  ApiResponse({required this.items});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
    );
  }
}

class Item {
  final OpenState openState;
  final ClosedState closedState;
  final String ctaText;

  Item(
      {required this.openState,
      required this.closedState,
      required this.ctaText});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      openState: OpenState.fromJson(json['open_state']),
      closedState: ClosedState.fromJson(json['closed_state']),
      ctaText: json['cta_text'],
    );
  }
}

class OpenState {
  final Body body;

  OpenState({required this.body});

  factory OpenState.fromJson(Map<String, dynamic> json) {
    return OpenState(
      body: Body.fromJson(json['body']),
    );
  }
}

class ClosedState {
  final Body body;

  ClosedState({required this.body});

  factory ClosedState.fromJson(Map<String, dynamic> json) {
    return ClosedState(
      body: Body.fromJson(json['body']),
    );
  }
}

class Body {
  final String? title;
  final String? subtitle;
  final String? footer;
  final Card? card;
  final List<ItemDetails>? items;
  final Map<String, String>? key1;

  Body({
    this.title,
    this.subtitle,
    this.footer,
    this.card,
    this.items,
    this.key1,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      title: json['title'],
      subtitle: json['subtitle'],
      footer: json['footer'],
      card: json['card'] != null ? Card.fromJson(json['card']) : null,
      items: json['items'] != null
          ? List<ItemDetails>.from(
              json['items'].map((x) => ItemDetails.fromJson(x)))
          : null,
      key1:
          json['key1'] != null ? Map<String, String>.from(json['key1']) : null,
    );
  }
}

class Card {
  final String header;
  final String description;
  final int maxRange;
  final int minRange;

  Card({
    required this.header,
    required this.description,
    required this.maxRange,
    required this.minRange,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      header: json['header'],
      description: json['description'],
      maxRange: json['max_range'],
      minRange: json['min_range'],
    );
  }
}

class ItemDetails {
  final String emi;
  final String duration;
  final String title;
  final String subtitle;
  final String? tag;

  ItemDetails({
    required this.emi,
    required this.duration,
    required this.title,
    required this.subtitle,
    this.tag,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      emi: json['emi'],
      duration: json['duration'],
      title: json['title'],
      subtitle: json['subtitle'],
      tag: json['tag'],
    );
  }
}
