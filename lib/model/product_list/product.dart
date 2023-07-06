import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final int? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final String? brand;
  final String? category;
  final String? thumbnail;

  const Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        price: json['price'] as int?,
        discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
        rating: (json['rating'] as num?)?.toDouble(),
        stock: json['stock'] as int?,
        brand: json['brand'] as String?,
        category: json['category'] as String?,
        thumbnail: json['thumbnail'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'discountPercentage': discountPercentage,
        'rating': rating,
        'stock': stock,
        'brand': brand,
        'category': category,
        'thumbnail': thumbnail,
      };

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      price,
      discountPercentage,
      rating,
      stock,
      brand,
      category,
      thumbnail,
    ];
  }
}
