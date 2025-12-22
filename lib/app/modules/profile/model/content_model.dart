class ContentModel {
    ContentModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final ContentData? data;

    factory ContentModel.fromJson(Map<String, dynamic> json){ 
        return ContentModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : ContentData.fromJson(json["data"]),
        );
    }

}

class ContentData {
    ContentData({
        required this.id,
        required this.privacyPolicy,
        required this.termsAndConditions,
        required this.aboutUs,
        required this.updatedAt,
    });

    final String? id;
    final String? privacyPolicy;
    final String? termsAndConditions;
    final String? aboutUs;
    final DateTime? updatedAt;

    factory ContentData.fromJson(Map<String, dynamic> json){ 
        return ContentData(
            id: json["id"],
            privacyPolicy: json["privacyPolicy"],
            termsAndConditions: json["termsAndConditions"],
            aboutUs: json["aboutUs"],
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}
