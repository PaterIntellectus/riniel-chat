import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/features/character/list/bloc/bloc.dart';
import 'package:riniel_chat/screens/home/ui/characters_tab/tab.dart';
import 'package:riniel_chat/screens/home/ui/chats_tab/bloc/bloc.dart';
import 'package:riniel_chat/screens/home/ui/chats_tab/tab.dart';

typedef HomeScreenTab = ({
  String title,
  Widget widget,
  BottomNavigationBarItem navBarItem,
});

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static final _tabs = <HomeScreenTab>[
    (
      title: 'Чаты',
      widget: BlocProvider(
        create: (context) {
          final bloc = ChatsTabBloc(
            context.read(),
            context.read(),
            context.read(),
          );
          bloc.add(ChatsTabStarted());
          return bloc;
        },
        child: Builder(builder: (context) => ChatsTab(bloc: context.read())),
      ),
      navBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Чаты',
        tooltip: 'Список чатов',
      ),
    ),
    (
      title: 'Персонажи',
      widget: BlocProvider(
        create: (context) {
          final bloc = CharacterListBloc(context.read());
          bloc.add(CharacterListStarted());
          return bloc;
        },
        child: Builder(
          builder: (context) => CharactersTab(bloc: context.read()),
        ),
      ),
      navBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Персонажи',
        tooltip: 'Список персонажей',
      ),
    ),
  ];

  late final _tabController = TabController(length: _tabs.length, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _tabs.elementAt(_tabController.index);

    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: _tabController,
          builder: (context, child) => Text(currentTab.title),
        ),
      ),
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
