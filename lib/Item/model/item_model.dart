enum ItemRentalPeriodType { day, week, month }

enum Category { manTop, manBottom, womanTop, womanBottom, etc }

class ItemModel {
  final String itemID;
  final String userID;
  final String title;
  final String thumbUrl;
  final ItemRentalPeriodType itemRentalPeriodType;
  final int price;
  final DateTime uploadTime;
  final String description;
  final Category category;

  ItemModel({
    required this.itemID,
    required this.userID,
    required this.title,
    required this.thumbUrl,
    required this.itemRentalPeriodType,
    required this.price,
    required this.uploadTime,
    required this.description,
    required this.category,
  });
}

// enum RestaurantPriceRange { expensive, medium, cheap }
//
// class RestaurantModel {
//   final String id;
//   final String name;
//   final String thumbUrl;
//   final List<String> tags;
//   final RestaurantPriceRange priceRange;
//   final double ratings;
//   final int ratingsCount;
//   final int deliveryTime;
//   final int deliveryFee;
//
//   RestaurantModel({
//     required this.id,
//     required this.name,
//     required this.thumbUrl,
//     required this.tags,
//     required this.priceRange,
//     required this.ratings,
//     required this.ratingsCount,
//     required this.deliveryTime,
//     required this.deliveryFee,
//   });
//
//   factory RestaurantModel.fromJson({
//     required Map<String, dynamic> json,
//   }) {
//     return RestaurantModel(
//       id: json['id'],
//       name: json['name'],
//       thumbUrl: json['thumbUrl'],
//       tags: List<String>.from(json['tags']),
//       priceRange: RestaurantPriceRange.values.firstWhere(
//         (e) => e.name == json['priceRange'],
//       ),
//       ratings: json['ratings'],
//       ratingsCount: json['ratingsCount'],
//       deliveryTime: json['deliveryTime'],
//       deliveryFee: json['deliveryFee'],
//     );
//   }
// }
