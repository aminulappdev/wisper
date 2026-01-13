class ChatsDataModel {
    ChatsDataModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final List<ChatsDataItemModel> data;

    factory ChatsDataModel.fromJson(Map<String, dynamic> json){ 
        return ChatsDataModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? [] : List<ChatsDataItemModel>.from(json["data"]!.map((x) => ChatsDataItemModel.fromJson(x))),
        );
    }

} 

class ChatsDataItemModel {
    ChatsDataItemModel({
        required this.id,
        required this.file,
        required this.fileType,
    });

    final String? id;
    final String? file;
    final String? fileType;

    factory ChatsDataItemModel.fromJson(Map<String, dynamic> json){ 
        return ChatsDataItemModel(
            id: json["id"],
            file: json["file"],
            fileType: json["fileType"],
        );
    }

}
