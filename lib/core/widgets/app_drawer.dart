import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Premium app drawer with navigation menu
/// Features:
/// - User profile section
/// - Navigation links (Wishlist, Orders, Cart)
/// - Dark mode toggle
/// - Smooth animations
class AppDrawer extends ConsumerWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onWishlistTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onCartTap;

  const AppDrawer({
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onWishlistTap,
    required this.onOrdersTap,
    required this.onCartTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with profile
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outlined,
                      size: 30,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // User info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'user@example.com',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Wishlist
          _DrawerMenuItem(
            icon: Icons.favorite_outline,
            title: 'My Wishlist',
            onTap: onWishlistTap,
          ),

          // Orders
          _DrawerMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            onTap: onOrdersTap,
          ),

          // Cart
          _DrawerMenuItem(
            icon: Icons.shopping_cart_outlined,
            title: 'Shopping Cart',
            onTap: onCartTap,
          ),

          const Divider(height: 24),

          // Dark mode toggle
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => onThemeToggle(),
            ),
          ),

          const Divider(height: 24),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(
              'Help & Support',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support Coming Soon')),
              );
            },
          ),

          // Settings
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings Coming Soon')),
              );
            },
          ),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              'About ShopSphere',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),

          const SizedBox(height: 32),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'ShopSphere v1.0.0',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ShopSphere'),
        content: const Text(
          'ShopSphere is a premium e-commerce app with a curated collection of beauty, fashion, and lifestyle products.\n\nVersion 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Custom drawer menu item
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }
}
