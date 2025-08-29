import 'package:flutter/material.dart';

const List<Widget> components = [
  MyApp(),
  MyButton(),
  MyText(),
  MyImg(),
  Icon(
    Icons.home,
    size: 40,
    color: Colors.red,
  ),
  MyGrid(),
  MyFlexHor(),
  MyFlexVer(),
  MyStack(),
  MyButtons(),
  MyAddNum()
];

void main() {
  runApp(const MaterialApp(
    // 要用顶部导航栏必须用DefaultTabController包裹 作为TabBar TabBarView的共同父组件才可以
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = const [TestPage1(), TestPage2()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack 缓存页面状态 切换可见的子组件
      // body: IndexedStack(
      //   index: _currentPageIndex,
      //   children: _pages,
      // ),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '测试页1'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '测试页2'),
        ],
      ),
    );
  }
}

class TestPage1 extends StatefulWidget {
  const TestPage1({super.key});

  @override
  State<TestPage1> createState() => _TestPage1State();
}

class _TestPage1State extends State<TestPage1> with TickerProviderStateMixin {
  // late 延迟初始化 告诉编译器这个变量在声明时不会立即被赋值 但会在第一次使用时被赋值
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    print('测试是否重新加载了测试页1');
    // 要使用this 必须用with关键字 混入 TickerProviderStateMixin 才能得到这个能力
    _tabController =
        TabController(length: 3, vsync: this); // 表示使用当前state实例作为 动画节拍器vsync
    // Tab切换过程监听事件
    _tabController.addListener(() {
      // 因为index索引变化并不是直接从0到1 而是浮点型过渡来控制动画 因此在过程中会一直触发
      // 所以要加判断等完全切换后在触发
      if (!_tabController.indexIsChanging) {
        print('Tab切换完毕：${_tabController.index}');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // 组件销毁前注销
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello123'),
        backgroundColor: Colors.yellow,
        bottom: TabBar(
          controller: _tabController, // 表示TabBar的行为和状态都由_tabController对象来控制
          tabs: const [
            Tab(text: '主页'),
            Tab(text: '喜欢'),
            Tab(text: '设置'),
          ],
        ),
      ),
      // body: const Column(
      //   children: [MyApp(), MyButton(), MyText(), MyImg()],
      // )),
      // body: const SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       MyApp(),
      //       MyButton(),
      //       MyText(),
      //       MyImg(),
      //       Icon(
      //         Icons.home,
      //         size: 40,
      //         color: Colors.red,
      //       )
      //     ],
      //   ),
      // ),
      // body: ListView(
      //   children: const [
      //     MyApp(),
      //     MyButton(),
      //     MyText(),
      //     MyImg(),
      //     Icon(
      //       Icons.home,
      //       size: 40,
      //       color: Colors.red,
      //     )
      //   ],
      // ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: components.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: components[index],
              );
            },
          ),
          const Center(child: Text('喜欢内容')),
          const Center(child: Text('设置内容')),
        ],
      ),
    );
  }
}

class TestPage2 extends StatelessWidget {
  const TestPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('测试页2'),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(40),
        // transform: Matrix4.translationValues(40, 0, 0),
        transform: Matrix4.rotationZ(0.2),
        decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.blue,
                blurRadius: 20,
              )
            ],
            gradient:
                const LinearGradient(colors: [Colors.red, Colors.yellow])),
        child: const Text(
          'world',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      // height: 40,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      child: const Text(
        '按钮',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  const MyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: const Text(
        '测试溢出显示asdasndioashdioahsdionasdnasklndoiqiohweuibqwiubdsaud',
        style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class MyImg extends StatelessWidget {
  const MyImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      decoration: const BoxDecoration(
        color: Colors.yellow,
        // borderRadius: BorderRadius.circular(50),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(
                'https://img1.baidu.com/it/u=2172818577,3783888802&fm=253&app=138&f=JPEG?w=800&h=1422'),
            fit: BoxFit.cover),
      ),
      // child: Image.network(
      //   'https://img1.baidu.com/it/u=2172818577,3783888802&fm=253&app=138&f=JPEG?w=800&h=1422',
      //   fit: BoxFit.cover,
      //   // repeat: ImageRepeat.repeat,
      // ),
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(1000),
      //   child: Image.network(
      //     'https://img1.baidu.com/it/u=2172818577,3783888802&fm=253&app=138&f=JPEG?w=800&h=1422',
      //     fit: BoxFit.fill,
      //   ),
      // ),
    );
  }
}

class MyGrid extends StatelessWidget {
  const MyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // 一定要加这个 因为外部容器是滚动 GridView也默认滚动 因此会冲突 设置shrinkWrap使GridView只占用其内容所需的空间
      shrinkWrap: true,
      // GridView虽然不再试图占满空间 但是依然默认滚动 父容器在滑动到GridView时无法触发自身滚动 因此要禁用自身滚动
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        // mainAxisExtent: 30, // 直接设置固定高度
        childAspectRatio: 2, // 宽/高 比例 自适应友好
      ),
      padding: const EdgeInsets.all(6),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Colors.red),
          child: Text(
            '$index',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      },
    );
  }
}

// Flex是Row Column的基类
class MyFlexHor extends StatelessWidget {
  const MyFlexHor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration:
          BoxDecoration(border: Border.all(width: 2, color: Colors.yellow)),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(color: Colors.red),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
          )
        ],
      ),
    );
  }
}

class MyFlexVer extends StatelessWidget {
  const MyFlexVer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100, // 不设宽度就是默认拉满
      height: 200,
      decoration:
          BoxDecoration(border: Border.all(width: 2, color: Colors.yellow)),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(color: Colors.red),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
          )
        ],
      ),
    );
  }
}

class MyStack extends StatelessWidget {
  const MyStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 300,
        decoration:
            BoxDecoration(border: Border.all(width: 6, color: Colors.yellow)),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 40,
              decoration: const BoxDecoration(color: Colors.black),
              child: const Text(
                '顶部固定',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Text(
                        'Text${index + 1}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ));
  }
}

class MyButtons extends StatelessWidget {
  const MyButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          const ElevatedButton(onPressed: null, child: Text('凸起按钮')),
          ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.send),
              label: const Text('凸起按钮加图标')),
          const TextButton(onPressed: null, child: Text('文本按钮')),
          TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.add),
              label: const Text('文本按钮加图标')),
          const OutlinedButton(onPressed: null, child: Text('边框按钮')),
          const IconButton(onPressed: null, icon: Icon(Icons.home))
        ],
      ),
    );
  }
}

class MyAddNum extends StatefulWidget {
  const MyAddNum({super.key});

  @override
  State<MyAddNum> createState() => _MyAddNumState();
}

class _MyAddNumState extends State<MyAddNum> {
  int _num = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(width: 2, color: Colors.red)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$_num',
            style: const TextStyle(fontSize: 20),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _num++;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.blue,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ))
        ],
      ),
    );
  }
}
