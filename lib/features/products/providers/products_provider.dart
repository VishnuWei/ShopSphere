import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/product.dart';
import '../../../services/product_api_service.dart';

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productApiServiceProvider).fetchProducts();
});

final productByIdProvider = Provider.family<Product?, int>((ref, id) {
  final products = ref
      .watch(productsProvider)
      .maybeWhen(data: (items) => items, orElse: () => const <Product>[]);
  return products.where((product) => product.id == id).firstOrNull;
});
