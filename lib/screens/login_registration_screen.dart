import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/profile_provider.dart';
import '../services/auth_service.dart';

class LoginRegistrationScreen extends ConsumerStatefulWidget {
  const LoginRegistrationScreen({super.key});

  @override
  ConsumerState<LoginRegistrationScreen> createState() => _LoginRegistrationScreenState();
}

class _LoginRegistrationScreenState extends ConsumerState<LoginRegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
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
      await ref.read(authServiceProvider).signUpWithEmailAndPassword(email, password);
      ref.read(profileProvider.notifier).login(
            name: 'Member',
            email: email,
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      _showMessage(AuthService.getErrorMessage(e));
    } catch (_) {
      _showMessage('Signup failed. Please try again.');
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 768;
          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: isDesktop
                    ? Row(
                        children: [
                          Expanded(child: _buildVisualHero()),
                          Expanded(child: _buildForm(context)),
                        ],
                      )
                    : _buildForm(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: const Border(bottom: BorderSide(color: Color(0x80F1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Color(0xFF334155)),
          Text(
            'MARCO POLO',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontFamily: 'Noto Serif',
              fontSize: 20,
              letterSpacing: 2.0,
            ),
          ),
          const Icon(Icons.shopping_bag_outlined, color: Color(0xFF334155)),
        ],
      ),
    );
  }

  Widget _buildVisualHero() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB4M1LZW0B8AyARNxsLXDoYmOdfzuQmdWz4rYunve8Kcu36K1zZJM_DKWVe6VSOZ4j838-5wcO6VIRvJaIzyNeTF9c1SFa23gEw9EpTYbuapssv6uBwQuRLGowhygtRzlGwyNe_kcjleKdAGnNJoPQeLn_4LpuYXLD9pfwjx7f91E7rO3CYAaT6xyBCtOo_IU9jrw0OcQOukxQG6A9lIS547jWi5LvL21qWvvV4CyOBYP_ASRkJwJD7n2oaDePSgMJJ-MCQu9SWbMA',
          fit: BoxFit.cover,
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curated Style for the Global Citizen.',
                  style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Access an exclusive world of high-fashion and artisanal craftsmanship.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 384),
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
                'Welcome back to Marco Polo',
                style: AppTheme.lightTheme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              Text(
                'EMAIL ADDRESS',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.outline,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.outlineVariant),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PASSWORD',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'FORGOT?',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.outline,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.outlineVariant),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.onSecondaryFixed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'SIGN IN',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppTheme.outlineVariant)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppTheme.outlineVariant)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppTheme.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuACuojbu_K8pYrNZ_WIccZAthplXJlcGeMiUY0v4wBKHILbsq-s5QAEF9WQeuPZwhCSn_o6bzXIafPXmwLL_vM_4tM5xWIMx0WIg1Zwm1aV0OhXbY_OWAEAdLQl_PdQ__oMxTD7WFnBwU8yJ3xKqMzSoojJST_eNTjG46PM7Y8TX3EhjplgE68URIE1sXm4ns9d7Ai3x8Yk8Rjim0404Cmr5BuGbc1XMuLOhm0PZHBJTMdz7Pv15E0brJcJEicHMTuvDN3MrF-i4vs',
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                      label: Text(
                        'GOOGLE',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppTheme.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.facebook, size: 20, color: Colors.grey),
                      label: Text(
                        'META',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'New to the collection?',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        side: const BorderSide(color: AppTheme.primary),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: Text(
                        'REQUEST AN INVITATION',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
