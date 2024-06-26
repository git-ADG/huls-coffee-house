import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huls_coffee_house/controllers/controllers.dart';
import 'package:huls_coffee_house/models/models.dart';
import 'package:huls_coffee_house/utils/local_database/local_database.dart';
import 'package:huls_coffee_house/utils/utils.dart';

part 'functions/_create_impl.dart';
part 'functions/_check_duplicate_impl.dart';
part 'functions/_save_impl.dart';
part 'functions/_get_impl.dart';
part 'functions/_get_all_impl.dart';
part 'functions/_get_quantity_impl.dart';
part 'functions/_delete_impl.dart';

class ProductController {
  static const String _collectionName = "products";
  const ProductController._();

  /// Creates a new product
  /// If product already exists, updates it
  static Future<ProductModel?> create(ProductModel product) async {
    return await _createImpl(product);
  }

  static Future<bool> _checkDuplicate(ProductModel product) async {
    return await _checkDuplicateImpl(product);
  }

  ///returns the quantity of the specified product from database
  static Future<num> getQuantity(ProductModel product) async {
    return await _getQuantityImpl(product);
  }

  // static Future<ProductModel> _save(ProductModel product) async {
  //   return await _saveImpl(product);
  // }

  /// For a given id returns all the data of the product
  static Stream<List<ProductModel>> get({
    String? id,
    String? category,
    String? itemName,
    bool forceGet = false,
  }) {
    return _getImpl(
      id: id,
      category: category,
      itemName: itemName,
      forceGet: forceGet,
    );
  }

  /// Returns the stream of all products available
  static Stream<List<ProductModel>> getAll({
    bool forceGet = false,
  }) {
    return _getAllImpl(
      forceGet: forceGet,
    );
  }

  /// Deletes a product from database
  static Future<void> delete(ProductModel product) async {
    return await _deleteImpl(product);
  }
}
