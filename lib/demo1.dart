import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 类似Vue中Watcher
      create: (context) => MyAppState(),
      child: MaterialApp(
        // 开箱即用的主题配色及导航等入口组件
        title: 'App',
        theme: ThemeData(
            useMaterial3: true, // 是否用新版Material3算法
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepOrange)), // 决定基准色
        home: const MyHomePage(),
      ),
    );
  }
}

// 状态管理 类似 Vuex 但是根据ChangeNotifierProvider挂载在哪一级决定其共享响应式变量范围
class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();

  void getNewWord() {
    current = WordPair.random();
    notifyListeners(); // 必须要调用这个方法通知监听器
  }

  // List<WordPair> favorites = [];
  Set<WordPair> favorites = {};

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  // 根据所选导航项 切换页面内容
  final List<Widget> _pages = const [GeneratorPage(), Placeholder()];
  // 点击切换导航项
  void _changeSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕方向
    final Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      // 竖屏
      return Scaffold(
        body: _pages[_selectedIndex],
        // 竖屏时 使用脚手架内置的底部导航栏
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _changeSelected,
        ),
      );
    } else {
      // 横屏
      return Scaffold(
        // 不同系统下可能有一些系统操作条 会遮挡页面 因此用SafeArea添加内边距避免
        body: SafeArea(
          // 侧边栏没有内置配置项
          child: Row(
            children: [
              NavigationRail(
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: _changeSelected,
                extended: true, // 横屏时展开
              ),
              Expanded(
                child: _pages[_selectedIndex],
              )
            ],
          ),
        ),
      );
    }
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 为了调用修改状态数据的方法 需要获取appState
    MyAppState appState = context.read<MyAppState>();

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer, // 主页应用主题配色
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('随机单词：'),
            const SizedBox(
              height: 10,
            ),
            const BigCard(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const FavoriteButton(),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () => appState.getNewWord(),
                  child: const Text('下一个'),
                ),
              ],
            )
          ],
        ),
      ),
    );
    // 或者 用Consumer监听范围限制在builder方法中 只重建一小部分 widget 树而不是整个 build 方法
    // return Consumer<MyAppState>(
    //   builder: (context,appState,child) {
    //     return Text(appState.current.asLowerCase);
    //   }
    // );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    // 监听对象或数组本身不会引起重绘 所以监current 是否在 favorites 列表中 当 favorites 或 current 变化时，都会重新计算
    final bool isFavorite = context.select<MyAppState, bool>(
        (value) => value.favorites.contains(value.current));

    MyAppState appState = context.read<MyAppState>();
    final IconData icon = isFavorite ? Icons.favorite : Icons.favorite_border;

    return ElevatedButton.icon(
      onPressed: () => appState.toggleFavorite(),
      icon: Icon(icon),
      label: const Text('喜欢'),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 从context获取当前主题
    // TextStyle 对象不可修改 copyWith 返回一个新的对象 包含所有旧对象属性 但指定修改的属性会使用新值
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    // 这种方式类似 Vue中watch深度监听一整个对象 会导致不必要的组件更新
    // var appState = context.watch<MyAppState>();
    // select 类似 watch监听对象下属性 更精准
    WordPair currentWord =
        context.select<MyAppState, WordPair>((appState) => appState.current);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${currentWord.first} ${currentWord.second}',
          style: style,
        ),
      ),
    );
  }
}
