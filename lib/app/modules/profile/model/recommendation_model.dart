class RecommendationModel {
  RecommendationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<RecommendationItemModel> data;

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<RecommendationItemModel>.from(
              json["data"]!.map((x) => RecommendationItemModel.fromJson(x)),
            ),
    );
  }
}

class RecommendationItemModel {
  RecommendationItemModel({
    required this.id,
    required this.rating,
    required this.text,
    required this.giver,
  });

  final String? id;
  final dynamic rating;
  final String? text;
  final Giver? giver;

  factory RecommendationItemModel.fromJson(Map<String, dynamic> json) {
    return RecommendationItemModel(
      id: json["id"],
      rating: json["rating"],
      text: json["text"],
      giver: json["giver"] == null ? null : Giver.fromJson(json["giver"]),
    );
  }
}

class Giver {
  Giver({required this.id, required this.person, required this.business});

  final String? id;
  final Person? person;
  final Business? business;

  factory Giver.fromJson(Map<String, dynamic> json) {
    return Giver(
      id: json["id"],
      person: json["person"] == null ? null : Person.fromJson(json["person"]),
      business: json["business"] == null
          ? null
          : Business.fromJson(json["business"]),
    );
  }
}

class Person {
  Person({required this.id, required this.name, required this.image});

  final String? id;
  final String? name;
  final String? image;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(id: json["id"], name: json["name"], image: json["image"]);
  }
}

class Business {
  Business({required this.id, required this.name, required this.image});

  final String? id;
  final String? name;
  final String? image;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(id: json["id"], name: json["name"], image: json["image"]);
  }
}
