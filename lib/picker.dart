import 'package:flutter/material.dart';
import 'package:hackthons/map.dart';
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
      home: IngredientSelectionPage(),
    );
  }
}

class IngredientSelectionPage extends StatefulWidget {
  @override
  _IngredientSelectionPageState createState() =>
      _IngredientSelectionPageState();
}

class _IngredientSelectionPageState extends State<IngredientSelectionPage> {
  SwipableStackController _stackController;

  List<String> _ingredientPictures;

  List<String> _ingredientNames;

  @override
  void initState() {
    super.initState();
    _stackController = SwipableStackController();

    _ingredientPictures = [
      "images/pic_one.jpg",
      "images/pic_two.jpg",
      "images/pic_three.jpg",
      "images/pic_four.jpg",
    ];

    _ingredientNames = [
      "Ingredient One",
      "Ingredient Two"
          "Ingredient Three"
          "Ingredient Four"
    ];
  }

  @override
  Widget build(BuildContext context) {
    int _cardsSwiped = 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Pick Your Ingredients",
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Center(
                child: SwipableStack(
                  overlayBuilder:
                      (context, constraints, index, direction, swipeProgress) {
                    if (direction == SwipeDirection.right) {
                      return Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.green,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      );
                    } else if (direction == SwipeDirection.left) {
                      return Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.red,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Opacity(opacity: 0));
                    }
                  },
                  controller: _stackController,
                  builder: (context, index, constraints) {
                    return Center(
                      child: _CustomCard(
                        image: _ingredientPictures.elementAt(index),
                        label: _ingredientPictures.elementAt(index),
                      ),
                    );
                  },
                  itemCount: _ingredientPictures.length,
                  onWillMoveNext: (index, direction) {
                    final allowedActions = [
                      SwipeDirection.right,
                      SwipeDirection.left,
                    ];
                    return allowedActions.contains(direction);
                  },
                  onSwipeCompleted: (index, direction) {
                    print('$index, $direction');
                    _cardsSwiped += 1;
                    if (_cardsSwiped == _ingredientPictures.length) {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("We're done!"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text(
                                        "You've just picked your ingredient list."),
                                    Text(
                                        "Would you like to continue or restart?")
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Continue"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MapView()));
                                  },
                                ),
                                TextButton(
                                  child: Text("Restart"),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                            IngredientSelectionPage(),
                                        transitionDuration:
                                        Duration(seconds: 0),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
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
                          icon: Icon(Icons.close, color: Colors.white),
                          color: Colors.red,
                          onTap: () {
                            _stackController.next(
                                swipeDirection: SwipeDirection.left);
                          }),
                      _CustomButton(
                          icon: Icon(Icons.check, color: Colors.white),
                          color: Colors.green,
                          onTap: () {
                            _stackController.next(
                                swipeDirection: SwipeDirection.right);
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  final String image;
  final String label;

  const _CustomCard({Key key, @required this.image, @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.white
            ),
          )
        ],
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