import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/database.dart';
import 'package:projekt_inzynieria_oprogramowania/login_panel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Database()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //bez stanu - statyczny obraz bez zmian
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const LoginPanel(), //przekazanie parametru o nazwie title
    );
  }
}
