import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'services/cart_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox<Map<dynamic, dynamic>>(CartStorageService.cartBoxName);
  await Hive.openBox<String>('theme_settings');
  await Hive.openBox<bool>('app_settings');
  await Hive.openBox<bool>('wishlist');
  await Hive.openBox<Map<dynamic, dynamic>>('orders');

  runApp(const ProviderScope(child: ShopSphereApp()));
}

class ShopSphereApp extends ConsumerWidget {
  const ShopSphereApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'ShopSphere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
