import 'package:flutter/material.dart';
import 'package:pixabay/service/api_service.dart';
import 'package:pixabay/views/home_page.dart';
import 'package:pixabay/views/provider/home_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeProvider(api: ApiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixabay Demo',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
