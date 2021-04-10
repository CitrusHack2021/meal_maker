import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images = [
    "images/pic_one.jpg",
    "images/pic_two.jpg",
    "images/pic_three.jpg",
    "images/pic_four.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final _swipeController = SwipableStackController();
    bool darkModeOn = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Your Ingredients"),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Stack(
              children: [
                SwipableStack(
                  overlayBuilder:
                      (context, constraints, index, direction, swipeProgress) {
                    if (direction == SwipeDirection.right) {
                      return Opacity(
                        opacity: 0.5,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.green,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ),
                        ),
                      );
                    } else if (direction == SwipeDirection.left) {
                      return Opacity(
                        opacity: 0.5,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.red,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Opacity(opacity: 0);
                    }
                  },
                  controller: _swipeController,
                  builder: (context, index, constraints) {
                    return _SingleCard(image: images.elementAt(index));
                  },
                  itemCount: images.length,
                  onWillMoveNext: (index, direction) {
                    final allowedActions = [
                      SwipeDirection.right,
                      SwipeDirection.left,
                    ];
                    return allowedActions.contains(direction);
                  },
                  onSwipeCompleted: (index, direction) {
                    print('$index, $direction');
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _CustomButton(
                            icon: Icon(
                              Icons.undo,
                              color: darkModeOn ? Colors.black : Colors.white
                            ),
                            color: Colors.blue,
                            onTap: () {
                              _swipeController.rewind();
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleCard extends StatelessWidget {
  final String image;

  const _SingleCard({Key key, @required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          image,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton(
      {Key key,
      @required this.icon,
      @required this.onTap,
      @required this.color})
      : super(key: key);
  final Icon icon;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: 80,
        child: icon,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
