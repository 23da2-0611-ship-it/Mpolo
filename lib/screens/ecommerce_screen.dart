import 'package:flutter/material.dart';
import 'home_screen.dart';

class EcommerceScreen extends StatelessWidget {
  const EcommerceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse HomeScreen layout for the ecommerce reference page
    return const HomeScreen();
  }
}
