import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postapp/common/theme/colors.dart';
import 'package:postapp/core/route/go_router_provider.dart';

class MainWidget extends ConsumerWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: ThemeData(
        scaffoldBackgroundColor: PostColors.scaffold,
        appBarTheme: const AppBarTheme(
          color: PostColors.scaffold, // Set AppBar to a blue color
        ),
      ),
    );
  }
}