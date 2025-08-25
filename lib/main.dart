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
  MyFlexVer()
];

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar:
          AppBar(title: const Text('Hello123'), backgroundColor: Colors.yellow),
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
      body: ListView.builder(
        itemCount: components.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: components[index],
          );
        },
      ),
    ),
  ));
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
