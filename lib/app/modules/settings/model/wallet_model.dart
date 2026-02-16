class AllTransectionModel {
  AllTransectionModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory AllTransectionModel.fromJson(Map<String, dynamic> json) {
    return AllTransectionModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({required this.meta, required this.payments});

  final Meta? meta;
  final List<TransectionItemModel> payments;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      payments: json["payments"] == null
          ? []
          : List<TransectionItemModel>.from(
              json["payments"]!.map((x) => TransectionItemModel.fromJson(x)),
            ),
    );
  }
}

class Meta {
  Meta({required this.page, required this.limit, required this.total});

  final int? page;
  final int? limit;
  final int? total;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(page: json["page"], limit: json["limit"], total: json["total"]);
  }
}

class TransectionItemModel {
  TransectionItemModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.transactionId,
    required this.auth,
  });

  final String? id;
  final int? amount;
  final DateTime? date;
  final String? transactionId;
  final Auth? auth;

  factory TransectionItemModel.fromJson(Map<String, dynamic> json) {
    return TransectionItemModel(
      id: json["id"],
      amount: json["amount"],
      date: DateTime.tryParse(json["date"] ?? ""),
      transactionId: json["transactionId"],
      auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
    );
  }
}

class Auth {
  Auth({required this.id, required this.person, required this.business});

  final String? id;
  final Person? person;
  final Business? business;

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json["id"],
      person: json["person"] == null ? null : Person.fromJson(json["person"]),
      business: json["business"] == null
          ? null
          : Business.fromJson(json["business"]),
    );
  }
}

class Person {
  Person({required this.name, required this.image});

  final String? name;
  final String? image;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(name: json["name"], image: json["image"]);
  }
}

class Business {
  Business({required this.name, required this.image});

  final String? name;
  final String? image;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(name: json["name"], image: json["image"]);
  }
}
