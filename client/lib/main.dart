import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/presentation/auth_notifier.dart';
import 'features/auth/presentation/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      home: authState.when(
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stackTrace) => const LoginScreen(),
        data: (user) {
          if (user != null) {
            return Scaffold(
              body: Center(child: Text('Logged in as ${user.email}')),
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
