class RolesModel {
    RolesModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory RolesModel.fromJson(Map<String, dynamic> json){ 
        return RolesModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.meta,
        required this.roles,
    });

    final Meta? meta;
    final List<RoleItemModel> roles;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            roles: json["roles"] == null ? [] : List<RoleItemModel>.from(json["roles"]!.map((x) => RoleItemModel.fromJson(x))),
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

class RoleItemModel {
    RoleItemModel({
        required this.id,
        required this.person,
        required this.count,
    });

    final String? id;
    final Person? person;
    final Count? count;

    factory RoleItemModel.fromJson(Map<String, dynamic> json){ 
        return RoleItemModel(
            id: json["id"],
            person: json["person"] == null ? null : Person.fromJson(json["person"]),
            count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
        );
    }

}

class Count {
    Count({
        required this.posts,
        required this.receivedRecommendations,
    });

    final int? posts;
    final int? receivedRecommendations;

    factory Count.fromJson(Map<String, dynamic> json){ 
        return Count(
            posts: json["posts"],
            receivedRecommendations: json["receivedRecommendations"],
        );
    }

}

class Person {
    Person({
        required this.name,
        required this.image,
        required this.title,
    });

    final String? name;
    final String? image;
    final String? title;

    factory Person.fromJson(Map<String, dynamic> json){ 
        return Person(
            name: json["name"],
            image: json["image"],
            title: json["title"],
        );
    }

}
