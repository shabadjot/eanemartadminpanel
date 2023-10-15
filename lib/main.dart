import 'package:eanemart_admin_panel/app_provider.dart';
import 'package:eanemart_admin_panel/constants/theme.dart';
import 'package:eanemart_admin_panel/helpers/firebase_storage_helper/firebase_option.dart';
import 'package:eanemart_admin_panel/screens/home_page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider()
        ..getUserListFun()
        ..getCategoryListFun(),
      child: MaterialApp(
        title: 'Eane admin panel',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
