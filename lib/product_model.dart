//listing model "pid": "23",
//     "name": "White Checkered Shirt",
//     "description": "The Indian Garage Co. Men Checkered Casual White Shirt",
//     "image":
//         "https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRSVYLiFm6YNHcCSLEuL4hZw9Jg4H6EcqfK3sujQYw7Rexvz2z0Mo5hT3Ea4g&usqp=CAE",
//     "price": "640"
//   },
import 'dart:convert';

import 'package:hackverse/sample2.dart';

class Listing {
  final String pid;
  final String name;
  final String description;
  final String image;
  final String price;

  Listing({
    required this.pid,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });
  //from json

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      pid: json['pid'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
    );
  }
}

class Shop {
  final String sid;
  final String name;
  final String image;
  final String phone;
  final String address;
  final List<Listing> products;

  Shop({
    required this.sid,
    required this.name,
    required this.image,
    required this.phone,
    required this.address,
    required this.products,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      sid: json['sid'],
      name: json['name'],
      image: json['image'],
      phone: json['phone'],
      address: json['address'],
      products:
          (json['products'] as List).map((e) => Listing.fromJson(e)).toList(),
    );
  }

  List<Shop> parseShops(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Shop>((json) => Shop.fromJson(json)).toList();
  }

  //find a shop by id
  Shop findShopById(String id, List<Shop> shops) {
    return shops.firstWhere((element) => element.sid == id);
  }
}
