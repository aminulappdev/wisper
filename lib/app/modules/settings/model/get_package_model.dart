class GetPackageModel {
  GetPackageModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<GetPackageItemModel> data;

  factory GetPackageModel.fromJson(Map<String, dynamic> json) {
    return GetPackageModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<GetPackageItemModel>.from(
              json["data"]!.map((x) => GetPackageItemModel.fromJson(x)),
            ),
    );
  }
}

class GetPackageItemModel {
  GetPackageItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.status,
  });

  final String? id;
  final String? name;
  final int? price;
  final String? duration;
  final String? status;

  factory GetPackageItemModel.fromJson(Map<String, dynamic> json) {
    return GetPackageItemModel(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      duration: json["duration"],
      status: json["status"],
    );
  }
}
