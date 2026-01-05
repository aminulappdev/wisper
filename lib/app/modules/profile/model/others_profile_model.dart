class OthersProfileModel {
    OthersProfileModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory OthersProfileModel.fromJson(Map<String, dynamic> json){ 
        return OthersProfileModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.auth,
        required this.isConnected,
    });

    final Auth? auth;
    final bool? isConnected;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
            isConnected: json["isConnected"],
        );
    }

}

class Auth {
    Auth({
        required this.id,
        required this.createdAt,
        required this.person,
    });

    final String? id;
    final DateTime? createdAt;
    final Person? person;

    factory Auth.fromJson(Map<String, dynamic> json){ 
        return Auth(
            id: json["id"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            person: json["person"] == null ? null : Person.fromJson(json["person"]),
        );
    }

}

class Person {
    Person({
        required this.id,
        required this.name,
        required this.email,
        required this.image,
        required this.phone,
        required this.title,
        required this.industry,
        required this.address,
    });

    final String? id;
    final String? name;
    final String? email;
    final String? image;
    final String? phone;
    final String? title;
    final String? industry;
    final dynamic address;

    factory Person.fromJson(Map<String, dynamic> json){ 
        return Person(
            id: json["id"],
            name: json["name"],
            email: json["email"],
            image: json["image"],
            phone: json["phone"],
            title: json["title"],
            industry: json["industry"],
            address: json["address"],
        );
    }

}
