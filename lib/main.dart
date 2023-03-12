import 'package:ec_shop_app/helper/custom_route_page.dart';
import 'package:ec_shop_app/providers/auth.dart';
import 'package:ec_shop_app/providers/cart.dart';
import 'package:ec_shop_app/providers/order.dart';
import 'package:ec_shop_app/providers/products_provider.dart';
import 'package:ec_shop_app/screens/cart_screen.dart';
import 'package:ec_shop_app/screens/edit_product_screen.dart';
import 'package:ec_shop_app/screens/loading_screen.dart';
import 'package:ec_shop_app/screens/order_screen.dart';
import 'package:ec_shop_app/screens/product_management.dart';
import 'package:provider/provider.dart';
import 'package:ec_shop_app/screens/product_detail_screen.dart';
import 'package:ec_shop_app/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:ec_shop_app/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    print('Main build');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (_, auth, previousProducts) => Products()
            ..update(auth.token ?? '', previousProducts?.getProducts ?? [],
                auth.useriD ?? ''),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order(),
          update: (_, auth, previousOrder) => Order()
            ..update(auth.token ?? '', previousOrder?.orders ?? [],
                auth.useriD ?? ''),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-commerce shop app',
          theme: ThemeData(
              // primaryColor: Colors.teal,
              // colorScheme: ColorScheme.fromSwatch(
              //     primarySwatch: Colors.teal, accentColor: Colors.deepOrange),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.deepOrange, primary: Colors.teal),
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {  //transitions animation base on platform
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              }),
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline5: const TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                    bodyText1: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    bodyText2: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    headline3: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                    headline6: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  )),
          home: authData.isAuth()
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.autoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const LoadingScreen()
                          : const AuthScreen()),
          routes: {
            AuthScreen.routeName: (context) => const AuthScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            ProductOverviewScreen.routeName: (context) =>
                const ProductOverviewScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            ProductManagement.routeName: (context) => const ProductManagement(),
            EditProductScreen.routeName: (context) => const EditProductScreen()
          },
        ),
      ),
    );
  }
}
