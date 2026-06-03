import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = {
      'Home': '/home',
      'Product Listing': '/listing',
      'Product Details': '/details',
      'Cart': '/cart',
      'Checkout': '/checkout',
      'Profile': '/profile',
      'Login / Register': '/login',
      'Ecommerce (Hero)': '/ecommerce',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marco Polo — Onboarding'),
        backgroundColor: AppTheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Quick Navigation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Tap a screen to jump directly to its reference implementation.'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: routes.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final title = routes.keys.elementAt(index);
                  final path = routes.values.elementAt(index);
                  return ListTile(
                    title: Text(title),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, path),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondary),
                child: const Text('Start Using App'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
