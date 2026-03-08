import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/policy_repository_impl.dart';
import 'data/services/platform_service.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/views/home_screen.dart';

void main() {
  final platformService = PlatformService();
  final policyRepository = PolicyRepositoryImpl(platformService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel(policyRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locker Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
