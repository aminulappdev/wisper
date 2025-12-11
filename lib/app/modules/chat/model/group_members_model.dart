class GroupMembersModel {
  GroupMembersModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<GroupMembersItemModel> data;

  factory GroupMembersModel.fromJson(Map<String, dynamic> json) {
    return GroupMembersModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<GroupMembersItemModel>.from(
              json["data"]!.map((x) => GroupMembersItemModel.fromJson(x)),
            ),
    );
  }
}

class GroupMembersItemModel {
  GroupMembersItemModel({
    required this.id,
    required this.role,
    required this.auth,
  });

  final String? id;
  final String? role;
  final Auth? auth;

  factory GroupMembersItemModel.fromJson(Map<String, dynamic> json) {
    return GroupMembersItemModel(
      id: json["id"],
      role: json["role"],
      auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
    );
  }
}

class Auth {
  Auth({required this.id, required this.person, required this.business});

  final String? id;
  final Person? person;
  final dynamic business;

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json["id"],
      person: json["person"] == null ? null : Person.fromJson(json["person"]),
      business: json["business"],
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
