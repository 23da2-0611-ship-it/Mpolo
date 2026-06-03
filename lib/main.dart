import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/product_listing_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/ecommerce_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'providers/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  bool _isPublicRoute(String routeName) {
    return routeName == '/login' ||
        routeName == '/register' ||
        routeName == '/onboarding';
  }

  bool _requiresAuth(String routeName) {
    return !_isPublicRoute(routeName);
  }

  Route<dynamic> _buildRoute(String routeName, RouteSettings settings) {
    switch (routeName) {
      case '/':
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen(), settings: settings);
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen(), settings: settings);
      case '/listing':
        return MaterialPageRoute(builder: (_) => const ProductListingScreen(), settings: settings);
      case '/details':
        return MaterialPageRoute(builder: (_) => const ProductDetailsScreen(), settings: settings);
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen(), settings: settings);
      case '/checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutScreen(), settings: settings);
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen(), settings: settings);
      case '/register':
        return MaterialPageRoute(builder: (_) => const LoginRegistrationScreen(), settings: settings);
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);
      case '/ecommerce':
        return MaterialPageRoute(builder: (_) => const EcommerceScreen(), settings: settings);
      case '/order-confirmation':
        return MaterialPageRoute(builder: (_) => const OrderConfirmationScreen(), settings: settings);
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen(), settings: settings);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<User?>>(authStateChangesProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          ref.read(profileProvider.notifier).login(
                name: user.displayName ?? 'Member',
                email: user.email ?? '',
              );
        } else {
          ref.read(profileProvider.notifier).logout();
        }
      });
    });

    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        final isLoggedIn = user != null;
        return MaterialApp(
          title: 'Marco Polo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: isLoggedIn ? '/home' : '/login',
          onGenerateRoute: (settings) {
            final name = settings.name ?? '/onboarding';
            if (_requiresAuth(name) && !isLoggedIn) {
              return _buildRoute('/login', const RouteSettings(name: '/login'));
            }
            if (isLoggedIn && (name == '/login' || name == '/register')) {
              return _buildRoute('/home', const RouteSettings(name: '/home'));
            }
            return _buildRoute(name, settings);
          },
        );
      },
      loading: () => MaterialApp(
        title: 'Marco Polo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        title: 'Marco Polo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: Text('Authentication error: $error'),
          ),
        ),
      ),
    );
  }
}
