import 'package:flutter/material.dart';

import 'birds.dart';
import 'drugs.dart';
import 'eggs.dart';
import 'feeds.dart';
import 'index.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, this.index = 0}) : super(key: key);
  final int? index;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int _index;

  @override
  void initState() {
    _index = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _index,
          children: const [Index(), Birds(), Drugs(), Feeds(), Eggs()],
        ),
        bottomNavigationBar: BottomNavigationBar(
            // selectedItemColor: Colors.black,
            // unselectedItemColor: Colors.black54,
            showUnselectedLabels: true,
            onTap: (tappedItemIndex) => setState(() {
                  _index = tappedItemIndex;
                }),
            currentIndex: _index,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.pets), label: 'Birds'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.medical_information), label: 'Drugs'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood), label: 'Feed'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.egg), label: 'Eggs'),
            ]));
  }
}
