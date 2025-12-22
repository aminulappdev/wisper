class CommentModel {
    CommentModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory CommentModel.fromJson(Map<String, dynamic> json){ 
        return CommentModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.meta,
        required this.comments,
    });

    final Meta? meta;
    final List<CommentItemModel> comments;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            comments: json["comments"] == null ? [] : List<CommentItemModel>.from(json["comments"]!.map((x) => CommentItemModel.fromJson(x))),
        );
    }

}

class CommentItemModel {
    CommentItemModel({
        required this.id,
        required this.createdAt,
        required this.text,
        required this.isEdited,
        required this.author,
    });

    final String? id;
    final DateTime? createdAt;
    final String? text;
    final bool? isEdited;
    final Author? author;

    factory CommentItemModel.fromJson(Map<String, dynamic> json){ 
        return CommentItemModel(
            id: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            text: json["text"],
            isEdited: json["isEdited"],
            author: json["author"] == null ? null : Author.fromJson(json["author"]),
        );
    }

}

class Author {
    Author({
        required this.id,
        required this.role,
        required this.person,
        required this.business,
    });

    final String? id;
    final String? role;
    final Person? person;
    final dynamic business;

    factory Author.fromJson(Map<String, dynamic> json){ 
        return Author(
            id: json["id"],
            role: json["role"],
            person: json["person"] == null ? null : Person.fromJson(json["person"]),
            business: json["business"],
        );
    }

}

class Person {
    Person({
        required this.id,
        required this.name,
        required this.image,
    });

    final String? id;
    final String? name;
    final String? image;

    factory Person.fromJson(Map<String, dynamic> json){ 
        return Person(
            id: json["id"],
            name: json["name"],
            image: json["image"],
        );
    }

}

class Meta {
    Meta({
        required this.page,
        required this.limit,
        required this.total,
    });

    final int? page;
    final int? limit;
    final int? total;

    factory Meta.fromJson(Map<String, dynamic> json){ 
        return Meta(
            page: json["page"],
            limit: json["limit"],
            total: json["total"],
        );
    }

}
