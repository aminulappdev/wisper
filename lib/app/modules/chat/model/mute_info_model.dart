class MuteInfoModel {
  MuteInfoModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final MuteData? data;

  factory MuteInfoModel.fromJson(Map<String, dynamic> json) {
    return MuteInfoModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : MuteData.fromJson(json["data"]),
    );
  }
}

class MuteData {
  MuteData({
    required this.authId,
    required this.muteFor,
    required this.mutedAt,
  });

  final String? authId;
  final String? muteFor;
  final DateTime? mutedAt;

  factory MuteData.fromJson(Map<String, dynamic> json) {
    return MuteData(
      authId: json["authId"],
      muteFor: json["muteFor"],
      mutedAt: DateTime.tryParse(json["mutedAt"] ?? ""),
    );
  }
}
