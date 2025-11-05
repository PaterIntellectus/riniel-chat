import 'package:flutter/material.dart';
import 'package:riniel_chat/screen/character_list/ui/screen.dart';
import 'package:riniel_chat/screen/chat_list/ui/screen.dart';

class Tab {
  const Tab({required this.widget, required this.navBarItem});

  final Widget widget;
  final BottomNavigationBarItem navBarItem;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const _tabs = <Tab>[
    Tab(
      widget: ChatListScreen(),
      navBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Чаты',
        tooltip: 'Список чатов',
      ),
    ),
    Tab(
      widget: CharacterListScreen(),
      navBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Персонажи',
        tooltip: 'Список персонажей',
      ),
    ),
  ];

  late final _tabController = TabController(length: _tabs.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Логотип')),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => tab.widget).toList(),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _tabController,
        builder: (context, child) => BottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: (value) => _tabController.animateTo(value),
          items: _tabs.map((tab) => tab.navBarItem).toList(),
        ),
      ),
    );
  }
}
