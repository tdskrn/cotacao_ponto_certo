import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDto {
  final String productId;
  final String productName;
  final String productCategory;
  final String productUnity;
  final double quantity;
  final Timestamp? created_at;
  final Timestamp last_modified;

  ProductDto({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productUnity,
    required this.quantity,
    required this.last_modified,
    this.created_at,
  });

  factory ProductDto.fromMap(Map<String, dynamic> map) {
    return ProductDto(
      productId: map['productId'],
      productName: map['productName'],
      productCategory: map['productCategory'],
      productUnity: map['productUnity'],
      quantity: map['quantity'],
      created_at: map['created_at'],
      last_modified: map['last_modified'],
    );
  }

  Map<String, dynamic> toMap(String productId) {
    return {
      'productId': productId,
      'productName': productName,
      'productCategory': productCategory,
      'productUnity': productUnity,
      'quantity': quantity,
      'created_at': created_at,
      'last_modified': last_modified,
    };
  }
}
