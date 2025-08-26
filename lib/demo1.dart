import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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
        home: MyHomePage(),
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
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 这种方式类似 Vue中watch深度监听一整个对象 会导致不必要的组件更新
    // var appState = context.watch<MyAppState>();
    // select 类似 watch监听对象下属性 更精准
    WordPair currentWord =
        context.select<MyAppState, WordPair>((appState) => appState.current);
    // 为了调用修改状态数据的方法 需要获取appState
    MyAppState appState = context.read<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          const Text('随机单词：'),
          Text(currentWord.asLowerCase),
          ElevatedButton(
              onPressed: () => appState.getNewWord(), child: const Text('下一个'))
        ],
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
