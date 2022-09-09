import 'package:account_book/pages/home.dart';
import 'package:account_book/pages/list.dart';
import 'package:account_book/pages/setting.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const _screens = [
    ListPage(),
    HomePage(),
    SettingPage(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: "月間",
            tooltip: "月間ページ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "年間",
            tooltip: "年間ページ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "設定",
            tooltip: "設定ページ",
          ),
        ],
      ),
    );
  }
}
