import 'package:flutter/material.dart';
import 'package:nanen_stot/page/home_page.dart';
import 'package:nanen_stot/providers/chats_provider.dart';
import 'package:nanen_stot/providers/models_provider.dart';
import 'package:nanen_stot/screens/chat_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        //home: const HomePage(),
        home: const ChatScreen(),
        title: 'Speech to Text Test1',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple.shade200,
        ),
      ),
    );
  }
}
