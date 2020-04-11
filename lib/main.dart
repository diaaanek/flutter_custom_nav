import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(),
      backgroundColor: Color.fromARGB(255, 241, 246, 247),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  // Init Animation Controllers
  AnimationController _animationController;
  AnimationController _fadeOutController;

  // Init Animations
  Animation<double> _positionAnimation;
  Animation<double> _fadeFabOutAnimation;
  Animation<double> _fadeFabInAnimation;

  Tween<double> _positionTween;

  double fabIconAlpha = 1;

  // Current selected tab
  int currentSelected = 0;

  // Active Icons --> Set add post as first option on tab
  IconData activeIcon = Icons.add_circle;

  @override
  void initState() {
    super.initState();

    // Set up Tween init state
    _positionTween = Tween<double>(begin: 0, end: 0);

    // FADE OUT Animation Controller
    _fadeOutController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (500 ~/ 3),
      ),
    );

    // Set up the TRANSLATION Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    // Create the TRANSLATION Animation
    _positionAnimation = _positionTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    )..addListener(() => setState(() {}));

    // Create the FADE OUT Animation
    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut))

      //Set the Alpha value : will get animated from 1 to 0
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabOutAnimation.value;
        });
      })

      // Listen to the end of the Fade Out animation and ...
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            //activeIcon = nextIcon;
          });
        }
      });

    // Create the FADE IN Animation
    // Will be run everytime setState() is called

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0, 1, curve: Curves.easeOut)))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabInAnimation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
/*======================
  START : tabs container
======================*/
        Container(
          padding: EdgeInsets.only(bottom: 25.0),
          width: double.infinity,
          color: Colors.white,
          height: 100,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
/*======================
  START : tab items
======================*/

              // Home Feed Tab
              TabItem(
                selected: currentSelected == -1,
                iconData: Icons.home,
                title: "HOME",
                callbackFunction: () {
                  setState(() {
                    activeIcon = Icons.home;
                    currentSelected = -1;
                  });

                  _initAnimationAndStart(_positionAnimation.value, -1);
                },
              ),

              //Add Post Tab
              TabItem(
                selected: currentSelected == 0,
                iconData: Icons.add_circle,
                title: "ADD",
                callbackFunction: () {
                  setState(() {
                    activeIcon = Icons.add_circle;
                    currentSelected = 0;
                  });

                  _initAnimationAndStart(_positionAnimation.value, 0);
                },
              ),

              //Setting Tab
              TabItem(
                selected: currentSelected == 1,
                iconData: Icons.settings,
                title: "SETTINGS",
                callbackFunction: () {
                  setState(() {
                    activeIcon = Icons.settings;
                    currentSelected = 1;
                  });

                  _initAnimationAndStart(_positionAnimation.value, 1);
                },
              ),
            ],
          ),
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Align(
              heightFactor: 1,
              alignment: Alignment(_positionAnimation.value, 0),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0.0, -40.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          /*
                            background of circle SAME as background of page
                           */
                          Container(
                            height: 80,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 241, 246, 247),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),

                          /*
                            icosn container
                            wrapped inside a [Opacity] Widget so it can be faded in and out by the contollers
                            
                          */
                          Opacity(
                            opacity: fabIconAlpha,
                            child: Transform.translate(
                              offset: Offset(0.0, (25 - 25 * fabIconAlpha)),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  //
                                  /* The background of the circle */
                                  color: Colors.white,

                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),

                                  /* Box shadow aroudn the white circle */
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 0),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),

                                /*
                                  The Active icon
                                */
                                child: Icon(activeIcon,
                                    color: Colors.indigoAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*
                    
                      !! Can be improved !!
                    */
                    ClipPath(
                      clipper: CustomShape(),
                      child: Container(
                        width: 100,
                        height: 80,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
    _positionTween.begin = from;

    _positionTween.end = to;

    _fadeOutController.reset();

    // Reset the animation controller
    _animationController.reset();

    // Init the translation  animation
    _animationController.forward();

    // Init the fadeout animation
    _fadeOutController.forward();
  }
}

class TabItem extends StatefulWidget {
  final bool selected;
  final IconData iconData;
  final String title;
  final Function callbackFunction;

  TabItem({
    Key key,
    this.selected,
    this.iconData,
    this.title,
    this.callbackFunction,
  }) : super(key: key);

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.selected);
    return Expanded(
      child: GestureDetector(
        // On tap call the callback function passed from the Tabs List Container
        onTap: () => widget.callbackFunction(),

        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // TODOL change styles on non active icons
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: widget.selected ? 0.0 : 1.0,
                child: Icon(
                  widget.iconData,
                  size: 28,
                  color: Colors.black26,
                ),
              ),

              /*
               when the tab is selected the label slides down 
                and the icon slides up 
              */
              AnimatedContainer(
                height: widget.selected ? 10.0 : 0.0,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 200),
              ),

              // The Label

              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: widget.selected ? 1.0 : 0.0,
                child: Text(
                  "${widget.title}",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: .5,
                    fontFamily: "Avenir",
                    color: Colors.black26,
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

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    //path.moveTo(0.0, size.height/2);

    path.lineTo(0.0, size.height / 2);

    path.lineTo(size.width, size.height / 2);

    path.lineTo(size.width, size.height / 2);

    path.lineTo(size.width, 0.0);

    var firstEndPoint = Offset(size.width - 15.0, 15.0);
    var firstControlPont = Offset(size.width - 5.0, 0.0);

    path.quadraticBezierTo(
      firstControlPont.dx,
      firstControlPont.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondEndPoint = Offset(15.0, 15.0);
    var secondControlPont = Offset(size.width / 2, size.height * 0.7);

    path.quadraticBezierTo(
      secondControlPont.dx,
      secondControlPont.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    var thirdEndPoint = Offset(0.0, 0.0);
    var thirdControlPont = Offset(5.0, 0.0);

    path.quadraticBezierTo(
      thirdControlPont.dx,
      thirdControlPont.dy,
      thirdEndPoint.dx,
      thirdEndPoint.dy,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
