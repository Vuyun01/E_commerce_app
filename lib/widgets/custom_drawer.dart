import 'package:ec_shop_app/providers/auth.dart';
import 'package:ec_shop_app/providers/order.dart';
import 'package:ec_shop_app/screens/order_screen.dart';
import 'package:ec_shop_app/screens/product_management.dart';
import 'package:ec_shop_app/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 150,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: const Color.fromARGB(255, 124, 241, 23),
                  fontFamily: 'Raleway',
                  fontSize: 30),
            ),
          ),
          CustomDrawerItem(
            textSize: 20,
            icon: Icons.home,
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductOverviewScreen.routeName),
            text: 'Home',
          ),
          CustomDrawerItem(
            textSize: 20,
            icon: Icons.payment,
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
            text: 'My Orders',
          ),
          CustomDrawerItem(
            textSize: 20,
            icon: Icons.edit,
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductManagement.routeName),
            text: 'Manage products',
          ),
          CustomDrawerItem(
            textSize: 20,
            icon: Icons.logout,
            onTap: () {
              // Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
            text: 'Log out',
          ),
        ],
      ),
    );
  }
}
