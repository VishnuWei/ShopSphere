import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';
import '../models/product.dart';

final productApiServiceProvider = Provider<ProductApiService>((ref) {
  return ProductApiService(ref.watch(dioProvider));
});

class ProductApiService {
  const ProductApiService(this._dio);

  final Dio _dio;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.productsPath,
      );
      final products = response.data?['products'] as List<dynamic>? ?? const [];
      return products
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ProductApiException(_messageFor(error));
    } on Object {
      throw const ProductApiException(
        'Something went wrong. Please try again.',
      );
    }
  }

  String _messageFor(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'The request timed out. Check your connection and try again.';
    }
    if (error.response?.statusCode != null) {
      return 'Unable to load products. Server responded with ${error.response!.statusCode}.';
    }
    return 'Unable to connect. Check your internet connection.';
  }
}

class ProductApiException implements Exception {
  const ProductApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
