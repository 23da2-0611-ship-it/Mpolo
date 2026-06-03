import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/profile_provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter both email and password.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters long.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authServiceProvider).signInWithEmailAndPassword(email, password);
      ref.read(profileProvider.notifier).login(
            name: 'Member',
            email: email,
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      _showMessage(AuthService.getErrorMessage(e));
    } catch (_) {
      _showMessage('Sign in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isValidEmail(String email) {
    const emailRegex = r"^[^\s@]+@[^\s@]+\.[^\s@]+$";
    return RegExp(emailRegex).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceBright,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'MEMBER PORTAL',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to your account',
                  style: AppTheme.lightTheme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),

                Text('EMAIL ADDRESS', style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'name@example.com'),
                ),
                const SizedBox(height: 24),

                Text('PASSWORD', style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(color: AppTheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: '••••••••'),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.onSecondaryFixed, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text('SIGN IN', style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(color: Colors.white)),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
