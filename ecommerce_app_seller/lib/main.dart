import 'package:ecommerce_app_seller/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app_seller/views/products_screen/add_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'const/colors.dart';
import 'const/styles.dart';
import 'views/home_screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Laza Seller",
      theme: ThemeData(
          fontFamily: AppStyles.regular,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.darkFontGrey)),
          primaryColor: AppColors.mainColor,
          inputDecorationTheme: const InputDecorationTheme(
            prefixIconColor: AppColors.mainColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return AppColors.mainColor.withOpacity(0.2);
                  }
                  return Colors.transparent;
                },
              ),
            ),
          )),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else if (snapshot.hasData) {
              return const Home();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}
