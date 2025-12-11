class GroupInfoModel {
  GroupInfoModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) {
    return GroupInfoModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.image,
    required this.chat,
  });

  final String? id;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final dynamic image;
  final Chat? chat;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      image: json["image"],
      chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]),
    );
  }
}

class Chat {
  Chat({required this.count});

  final Count? count;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
    );
  }
}

class Count {
  Count({required this.participants});

  final int? participants;

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(participants: json["participants"]);
  }
}
