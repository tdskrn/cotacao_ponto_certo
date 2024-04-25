import 'dart:ui';

import 'package:cotacao_ponto_certo/Views/mainScreenView.dart';
import 'package:cotacao_ponto_certo/models/timeStampAdapter.dart';
import 'package:cotacao_ponto_certo/providers/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  Hive.registerAdapter(TimestampAdapter());
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        scrollBehavior: MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        }),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 0, 39, 71),
            secondary: Colors.black,
            background: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: MainScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
