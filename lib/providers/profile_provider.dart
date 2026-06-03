import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final bool isLoggedIn;
  final String name;
  final String email;
  final String membership;

  const UserProfile({
    required this.isLoggedIn,
    required this.name,
    required this.email,
    required this.membership,
  });

  UserProfile copyWith({
    bool? isLoggedIn,
    String? name,
    String? email,
    String? membership,
  }) {
    return UserProfile(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      name: name ?? this.name,
      email: email ?? this.email,
      membership: membership ?? this.membership,
    );
  }
}

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return const UserProfile(
      isLoggedIn: false,
      name: 'Guest',
      email: '',
      membership: '',
    );
  }

  void login({required String name, required String email}) {
    state = UserProfile(
      isLoggedIn: true,
      name: name,
      email: email,
      membership: 'MEMBER SINCE MAY 2026',
    );
  }

  void logout() {
    state = const UserProfile(
      isLoggedIn: false,
      name: 'Guest',
      email: '',
      membership: '',
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(() {
  return ProfileNotifier();
});
