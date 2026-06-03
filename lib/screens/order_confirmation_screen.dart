import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/cart_provider.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartProvider.notifier).subtotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: AppTheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.check_circle_outline, size: 96, color: AppTheme.primary),
            const SizedBox(height: 24),
            Text(
              'Order Ready',
              style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'Your order total is \$${subtotal.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'This is a demo checkout. Press Place Order to simulate a completed purchase and clear the cart.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed — cart cleared')));
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondary, padding: const EdgeInsets.symmetric(vertical:16, horizontal:40)),
              child: const Text('Place Order'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
