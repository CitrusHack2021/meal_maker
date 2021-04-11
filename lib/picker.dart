import 'package:flutter/material.dart';
import 'package:hackthons/map.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'dart:math' as math;

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

  List<String> _pickedIngredients;
  List<String> _ingredientList;

  String matchIngredients(List<String> ingredients) {
    List<int> scores = [];

    List<String> pizza = [
      "Cheese",
      "Bread/Breading",
      "Protein",
      "Pasta Sauce",
      "Bell Peppers",
      "Tomatoes"
    ];
    int tempScore = 0;
    ingredients.forEach((element) {
      if (pizza.contains(element)) {
        tempScore += 1;
      }
    });
    scores.add(tempScore);

    List<String> burger = [
      "Cheese",
      "Bread/Breading",
      "Protein",
      "Lettuce",
      "Tomatoes",
      "Guacamole"
    ];
    tempScore = 0;
    ingredients.forEach((element) {
      if (burger.contains(element)) {
        tempScore += 1;
      }
    });
    scores.add(tempScore);

    List<String> burrito = [
      "Guacamole",
      "Beans",
      "Rice",
      "Cheese",
      "Protein",
      "Seafood",
      "Tortilla"
    ];
    tempScore = 0;
    ingredients.forEach((element) {
      if (burrito.contains(element)) {
        tempScore += 1;
      }
    });
    scores.add(tempScore);

    List<String> breakfast = [
      "Syrup",
      "Cheese",
      "Egg",
      "Spinach",
      "Fruits",
      "Tomatoes",
      "Protein"
    ];
    tempScore = 0;
    ingredients.forEach((element) {
      if (breakfast.contains(element)) {
        tempScore += 1;
      }
    });
    scores.add(tempScore);

    List<String> phosushi = [
      "Noodles",
      "Protein",
      "Seafood",
      "Bell Peppers",
      "Rice"
    ];
    tempScore = 0;
    ingredients.forEach((element) {
      if (phosushi.contains(element)) {
        tempScore += 1;
      }
    });
    scores.add(tempScore);

    List<String> pasta = [
      "Pasta",
      "Pasta Sauce",
      "Spinach",
      "Cheese",
      "Bell Peppers",
      "Tomatoes"
    ];
    tempScore = 0;
    ingredients.forEach((element) {
      if (pasta.contains(element)) {
        tempScore += 1;
      }
    });
    scores.add(tempScore);

    int highScore = scores.reduce(math.max);
    int index = scores.indexOf(highScore);

    if (index == 0) {
      return "Pizza";
    } else if (index == 1) {
      return "Burger";
    } else if (index == 2) {
      return "Burrito";
    } else if (index == 3) {
      return "Breakfast";
    } else if (index == 4) {
      return "Pho + Sushi";
    } else if (index == 5) {
      return "Pasta";
    } else {
      return "Unknown";
    }
  }

  @override
  void initState() {
    super.initState();
    _stackController = SwipableStackController();

    _pickedIngredients = [];
    _pickedIngredients.clear();

    _ingredientList = [
      "Cheese",
      "Bread/Breading",
      "Rice",
      "Noodles",
      "Eggs",
      "Pasta",
      "Pasta Sauce",
      "BBQ Sauce",
      "Lettuce",
      "Spinach",
      "Seafood",
      "Tomatoes",
      "Tortillas",
      "Guacamole",
      "Protein",
      "Potatoes",
      "Beans",
      "Syrup",
      "Fruits",
      "Bell Peppers"
    ];
    _ingredientList.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    int _cardsSwiped = 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Build your meal",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.width,
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
                      child: _CardExample(
                        color: Colors.blue,
                        text: _ingredientList.elementAt(index),
                      ),
                    );
                  },
                  itemCount: _ingredientList.length,
                  onWillMoveNext: (index, direction) {
                    final allowedActions = [
                      SwipeDirection.right,
                      SwipeDirection.left,
                    ];
                    return allowedActions.contains(direction);
                  },
                  onSwipeCompleted: (index, direction) {
                    // print('$index, $direction');
                    _cardsSwiped += 1;

                    if (direction == SwipeDirection.right) {
                      _pickedIngredients.add(_ingredientList.elementAt(index));
                    }

                    String matchedFood = matchIngredients(_pickedIngredients);

                    if (_cardsSwiped == _ingredientList.length) {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Looks like you want $matchedFood."),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text ("Now it's time to find a place to eat!"),
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
                                                MapView(matchedFood)));
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
    );
  }
}

class _CardExample extends StatelessWidget {
  const _CardExample({
    Key key,
    this.color = Colors.indigo,
    this.text = "Card Example",
  }) : super(key: key);
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(38.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 7.0,
          color: Colors.transparent.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 36.0,
          // color: Colors.white,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold,
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
    return Container(
      height: 80,
      width: 80,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: TextButton(
        onPressed: onTap,
        child: icon,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: color)))),
      ),
    );
  }
}
