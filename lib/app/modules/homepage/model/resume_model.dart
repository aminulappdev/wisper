class ResumeModel {
    ResumeModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final List<ResumeItemModel> data;

    factory ResumeModel.fromJson(Map<String, dynamic> json){ 
        return ResumeModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? [] : List<ResumeItemModel>.from(json["data"]!.map((x) => ResumeItemModel.fromJson(x))),
        );
    }

}

class ResumeItemModel {
    ResumeItemModel({
        required this.id,
        required this.authorId,
        required this.name,
        required this.file,
        required this.fileSize,
        required this.createdAt,
    });

    final String? id;
    final String? authorId;
    final String? name;
    final String? file;
    final String? fileSize;
    final DateTime? createdAt;

    factory ResumeItemModel.fromJson(Map<String, dynamic> json){ 
        return ResumeItemModel(
            id: json["id"],
            authorId: json["authorId"],
            name: json["name"],
            file: json["file"],
            fileSize: json["fileSize"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
        );
    }

}
