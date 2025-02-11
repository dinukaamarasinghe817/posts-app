import 'package:go_router/go_router.dart';
import 'package:postapp/core/route/route_name.dart';
import 'package:postapp/features/posts/ui/screens/home_screen.dart';
import 'package:riverpod/riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
    ]
  );
});