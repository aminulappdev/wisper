class FeedJobModel {
    FeedJobModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory FeedJobModel.fromJson(Map<String, dynamic> json){ 
        return FeedJobModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.meta,
        required this.jobs,
    });

    final Meta? meta;
    final List<FeedJobItemModel> jobs;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
            jobs: json["jobs"] == null ? [] : List<FeedJobItemModel>.from(json["jobs"]!.map((x) => FeedJobItemModel.fromJson(x))),
        );
    }

}

class FeedJobItemModel {
    FeedJobItemModel({
        required this.id,
        required this.author,
        required this.title,
        required this.description,
        required this.salary,
        required this.compensationType,
        required this.location,
        required this.type,
        required this.createdAt,
    });

    final String? id;
    final Author? author;
    final String? title;
    final String? description;
    final int? salary;
    final String? compensationType;
    final String? location;
    final String? type;
    final DateTime? createdAt;

    factory FeedJobItemModel.fromJson(Map<String, dynamic> json){ 
        return FeedJobItemModel(
            id: json["id"],
            author: json["author"] == null ? null : Author.fromJson(json["author"]),
            title: json["title"],
            description: json["description"],
            salary: json["salary"],
            compensationType: json["compensationType"],
            location: json["location"],
            type: json["type"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
        );
    }

}

class Author {
    Author({
        required this.id,
        required this.business,
    });

    final String? id;
    final Business? business;

    factory Author.fromJson(Map<String, dynamic> json){ 
        return Author(
            id: json["id"],
            business: json["business"] == null ? null : Business.fromJson(json["business"]),
        );
    }

}

class Business {
    Business({
        required this.id,
        required this.name,
        required this.industry,
        required this.address,
        required this.image,
    });

    final String? id;
    final String? name;
    final String? industry;
    final dynamic address;
    final dynamic image;

    factory Business.fromJson(Map<String, dynamic> json){ 
        return Business(
            id: json["id"],
            name: json["name"],
            industry: json["industry"],
            address: json["address"],
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
