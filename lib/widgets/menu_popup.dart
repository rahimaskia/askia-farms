import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/dashboard.dart';
import '../views/home_page.dart';
import '../views/login_page.dart';
import '../views/profile_page.dart';

class MenuPopup extends StatelessWidget {
  const MenuPopup({
    Key? key,
    required this.menus,
    required this.user,
  }) : super(key: key);

  final List<Map<String, dynamic>> menus;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) async {
          if (value == 'Logout') {
            FirebaseAuth.instance.signOut().then<void>((value) =>
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder: (context) => const LoginPage())));
          } else if (value == 'My Account') {
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder: (context) => const ProfilePage()));
          }
        },
        padding: EdgeInsets.zero,
        offset: const Offset(20, 55),
        itemBuilder: (context) => menus
            .map((item) => PopupMenuItem(
                value: item['title'],
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        item['icon'] as IconData,
                      ),
                    ),
                    Text('${item['title']}')
                  ],
                )))
            .toList(),
        icon: CircleAvatar(
          backgroundImage:
              NetworkImage(user?.photoURL ?? 'https://i.pravatar.cc/300'),
        ));
  }
}
