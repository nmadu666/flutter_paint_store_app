import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart';
import 'package:flutter_paint_store_app/models/branch.dart';
import 'package:flutter_paint_store_app/models/category.dart';
import 'package:flutter_paint_store_app/models/price_book.dart';
import 'package:flutter_paint_store_app/models/product.dart';

abstract class KiotVietDataRepository {
  Future<List<Branch>> getBranches();
  Future<List<Category>> getCategories();
  Future<List<PriceBook>> getPriceBooks();
  Future<List<Product>> getProducts();
}

class KiotVietDataRepositoryImpl implements KiotVietDataRepository {
  KiotVietDataRepositoryImpl(this._kiotVietService);

  final KiotVietService _kiotVietService;

  @override
  Future<List<Branch>> getBranches() async {
    final response = await _kiotVietService.getAll('/branches');
    final branches = response.map((json) => Branch.fromJson(json)).toList();
    return branches;
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await _kiotVietService.getAll('/categories');
    final categories = response.map((json) => Category.fromJson(json)).toList();
    return categories;
  }

  @override
  Future<List<PriceBook>> getPriceBooks() async {
    final response = await _kiotVietService.getAll('/pricebooks');
    final priceBooks = response.map((json) => PriceBook.fromJson(json)).toList();
    return priceBooks;
  }

  @override
  Future<List<Product>> getProducts() async {
    final response = await _kiotVietService.getAll('/products');
    final products = response.map((json) => Product.fromJson(json)).toList();
    return products;
  }
}
