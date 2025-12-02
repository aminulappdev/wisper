class BusinessModel {
  BusinessModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final BusinessData? data;

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : BusinessData.fromJson(json["data"]),
    );
  }
}

class BusinessData {
  BusinessData({required this.auth, required this.recommendations});

  final Auth? auth;
  final List<dynamic> recommendations;

  factory BusinessData.fromJson(Map<String, dynamic> json) {
    return BusinessData(
      auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
      recommendations: json["recommendations"] == null
          ? []
          : List<dynamic>.from(json["recommendations"]!.map((x) => x)),
    );
  }
}

class Auth {
  Auth({
    required this.id,
    required this.role,
    required this.createdAt,
    required this.business,
  });

  final String? id;
  final String? role;
  final DateTime? createdAt;
  final Business? business;

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json["id"],
      role: json["role"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      business: json["business"] == null
          ? null
          : Business.fromJson(json["business"]),
    );
  }
}

class Business {
  Business({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
    required this.industry,
    required this.address,
  });

  final String? id;
  final String? name;
  final String? email;
  final dynamic image;
  final dynamic phone;
  final String? industry;
  final dynamic address;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      phone: json["phone"],
      industry: json["industry"],
      address: json["address"],
    );
  }
}
