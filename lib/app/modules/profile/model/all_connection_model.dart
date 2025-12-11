class AllConnectionModel {
    AllConnectionModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory AllConnectionModel.fromJson(Map<String, dynamic> json){ 
        return AllConnectionModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.meta,
        required this.connections,
    });

    final Meta? meta;
    final List<AllConnectionItemModel> connections;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            connections: json["connections"] == null ? [] : List<AllConnectionItemModel>.from(json["connections"]!.map((x) => AllConnectionItemModel.fromJson(x))),
        );
    }

}

class AllConnectionItemModel {
    AllConnectionItemModel({
        required this.id,
        required this.partner,
        required this.status,
    });

    final String? id;
    final Partner? partner;
    final String? status;

    factory AllConnectionItemModel.fromJson(Map<String, dynamic> json){ 
        return AllConnectionItemModel(
            id: json["id"],
            partner: json["partner"] == null ? null : Partner.fromJson(json["partner"]),
            status: json["status"],
        );
    }

}

class Partner {
    Partner({
        required this.id,
        required this.person,
        required this.business,
    });

    final String? id;
    final Business? person;
    final Business? business;

    factory Partner.fromJson(Map<String, dynamic> json){ 
        return Partner(
            id: json["id"],
            person: json["person"] == null ? null : Business.fromJson(json["person"]),
            business: json["business"] == null ? null : Business.fromJson(json["business"]),
        );
    }

}

class Business {
    Business({
        required this.id,
        required this.image,
        required this.name,
        required this.industry,
        required this.title,
    });

    final String? id;
    final String? image;
    final String? name;
    final String? industry;
    final String? title;

    factory Business.fromJson(Map<String, dynamic> json){ 
        return Business(
            id: json["id"],
            image: json["image"],
            name: json["name"],
            industry: json["industry"],
            title: json["title"],
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
