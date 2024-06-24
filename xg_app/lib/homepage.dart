import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math'; // To find xG we need arctan function

// Aðalsíðan - Eina síðan
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // GlobalKey to update position on tap
  GlobalKey _paintKey = new GlobalKey();

  // The shot type that is currently selected - Starts as nothing
  var _currentShotType = "";

  // Current xG - Defualt is none
  var _currentXG = "";

  // Colors for shooting options
  // Regular shot
  Color _backgroundShotColor = Colors.white;
  Color _fontShotColor = Colors.black;

  //Heading
  Color _backgroundHeadingColor = Colors.white;
  Color _fontHeadingColor = Colors.black;

  // Penalty
  Color _backgroundPenaltyColor = Colors.white;
  Color _fontPenaltyColor = Colors.black;

  // The coordinates of the user Tap
  double _userTapX = 500.0;
  double _userTapY = 500.0;

  // Part of the image that's outside the pitch
  double _lowLimit = 0;

  // X and Y coordinates for the penalty spot starts as 0
  double _penX = 0;
  double _penY = 0;

  // X and Y factor to get distance in meters - starts as 0
  double xFactor = 0;
  double yFactor = 0;

  // X coordinate for center of goal - starts as 0
  double centerOfGoal = 0;

  // Reset state for all options
  dynamic _resetShot() {
    _backgroundShotColor = Colors.white;
    _fontShotColor = Colors.black;
  }

  dynamic _resetHeading() {
    _backgroundHeadingColor = Colors.white;
    _fontHeadingColor = Colors.black;
  }

  dynamic _resetPenalty() {
    _backgroundPenaltyColor = Colors.white;
    _fontPenaltyColor = Colors.black;
  }

  // The regular shooting option
  Widget _shootOption(optionname) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      child: GestureDetector(
        // Change color and current shot type when pressed
        onTap: () {
          setState(() {
            _backgroundShotColor == Colors.green
                ? _backgroundShotColor = Colors.white
                : _backgroundShotColor = Colors.green;

            _fontShotColor == Colors.white
                ? _fontShotColor = Colors.black
                : _fontShotColor = Colors.white;

            _resetHeading();
            _resetPenalty();

            _currentShotType == "Shot"
                ? _currentShotType = ""
                : _currentShotType = "Shot";

            // If shot type is deselected then remove circle from image
            if (_currentShotType == "") {
              _userTapX = 500.0;
              _userTapY = 500.0;
            }

            // Calculate xG
            _calculateXG();
          });
        },
        child: Card(
          color: _backgroundShotColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 80.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        optionname,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: _fontShotColor,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Heading option
  Widget _headingOption(optionname) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      child: GestureDetector(
        // Change color and current shot type when pressed
        onTap: () {
          setState(() {
            _backgroundHeadingColor == Colors.green
                ? _backgroundHeadingColor = Colors.white
                : _backgroundHeadingColor = Colors.green;

            _fontHeadingColor == Colors.white
                ? _fontHeadingColor = Colors.black
                : _fontHeadingColor = Colors.white;

            _resetShot();
            _resetPenalty();

            _currentShotType == "Heading"
                ? _currentShotType = ""
                : _currentShotType = "Heading";

            // If shot type is deselected then remove circle from image
            if (_currentShotType == "") {
              _userTapX = 500.0;
              _userTapY = 500.0;
            }

            // Calculate xG
            _calculateXG();
          });
        },
        child: Card(
          color: _backgroundHeadingColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 80.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        optionname,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: _fontHeadingColor,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Penalty option
  Widget _penaltyOption(optionname) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      child: GestureDetector(
        // Change color and current shot type when pressed
        onTap: () {
          setState(() {
            // Set the penalty spot to the correct place
            _penX = (MediaQuery.of(context).size.width) / (195 / 98);
            _penY = (MediaQuery.of(context).size.height / 2.5) / (70 / 15);

            _backgroundPenaltyColor == Colors.green
                ? _backgroundPenaltyColor = Colors.white
                : _backgroundPenaltyColor = Colors.green;

            _fontPenaltyColor == Colors.white
                ? _fontPenaltyColor = Colors.black
                : _fontPenaltyColor = Colors.white;

            _resetShot();
            _resetHeading();

            _currentShotType == "Penalty"
                ? _currentShotType = ""
                : _currentShotType = "Penalty";

            // If shot type is deselected then remove circle from image
            if (_currentShotType == "") {
              _userTapX = 500.0;
              _userTapY = 500.0;
            }
            // // If we have a penalty, keep circle on penalty spot
            else if (_currentShotType == "Penalty") {
              _userTapX = _penX;
              _userTapY = _penY;
            }

            // Calculate xG
            _calculateXG();
          });
        },
        child: Card(
          color: _backgroundPenaltyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 80.0,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        optionname,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: _fontPenaltyColor,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Find the coordinates of the user tap and calculate xG
  _onTapUp(TapUpDetails details) {
    // If no shot type is selected the X and Y values are more than possible - 500.0
    if (_currentShotType == "") {
      _userTapX = 500.0;
      _userTapY = 500.0;
    }
    // // If we have a penalty, keep circle on penalty spot
    else if (_currentShotType == "Penalty") {
      _userTapX = _penX;
      _userTapY = _penY;
    } else {
      _userTapX = details.globalPosition.dx;
      _userTapY = details.globalPosition.dy -
          (MediaQuery.of(context).padding.top +
              kToolbarHeight); // Subtrack the Top of the app
    }

    // Find the xG at given coordinate
    _calculateXG();

    // Update screen
    setState(() {});
  }

  // Calculate the xG at current position
  _calculateXG() {
    // Set the limits for factors
    xFactor = MediaQuery.of(context).size.width / 105;
    yFactor = (MediaQuery.of(context).size.height / 2.5) / 55;

    centerOfGoal = (MediaQuery.of(context).size.width / 2) + 1;

    _lowLimit = (MediaQuery.of(context).size.height / (211 / 2));

    // Find the distance of x from center of goal
    double xDistFromCenterOfGoal = (_userTapX - centerOfGoal - 1).abs();

    // Find the distance for the coordinates from the center of the goal in meters
    double xMeterDist = xDistFromCenterOfGoal / xFactor;
    double yMeterDist = (_userTapY - _lowLimit) / yFactor;

    // Find distance - a^2 + b^2 = c^2
    double dist = sqrt(pow(xMeterDist, 2) + pow(yMeterDist, 2));

    // Find angle from center of goal - tan^-1(ydist/xdistfrom center)
    double angle = atan(_userTapY / xDistFromCenterOfGoal) - pi / 2;

    // If nothing is selected
    if (_currentShotType == "" || _userTapY < _lowLimit)
      _currentXG = "";

    // If shot type is a penalty, the xG is alsways 0.79
    else if (_currentShotType == "Penalty")
      _currentXG = "0.79";

    // If shot type is a regular shot
    else if (_currentShotType == "Shot" &&
        (_userTapX != 500.0 || _userTapY != 500.0)) {
      _currentXG = (1 / (exp(0.14 * dist + 0.05 * angle))).toStringAsFixed(2);
    }

    // If shot type is a header
    else if (_currentShotType == "Heading" &&
        (_userTapX != 500.0 || _userTapY != 500.0)) {
      _currentXG = (1 / (exp(0.28 * dist + 0.4 * angle))).toStringAsFixed(2);
    }
  }

  // Display the xG if applicable
  Widget _displayXG() {
    var xGValue = "";
    // If nothing has been pressed, then don't display anything
    if (_currentXG != "") xGValue = "xG: " + _currentXG;

    return Text(
      xGValue,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.title))),
      // xG Calculator
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                // Hálfur fótboltavöllur - fyllir hálfan skjáinn
                GestureDetector(
                  // Find where the user pressed the image
                  onTapUp: (TapUpDetails details) => _onTapUp(details),
                  // Insert image
                  child: RepaintBoundary(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Image.asset('images/half_pitch.png',
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                // Draw circle
                CustomPaint(
                  painter: OpenPainter(_userTapX, _userTapY, _lowLimit),
                ),
              ],
            ),
            // Display xG if applicable
            Container(
              height: MediaQuery.of(context).size.height / 20,
              child: Center(
                child: _displayXG(),
              ),
            ),
            Expanded(
              child: ListView(
                // Build the list of options
                children: [
                  _shootOption("Shot"),
                  _headingOption("Header"),
                  _penaltyOption("Penalty"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Draw a circle where user taps screen
class OpenPainter extends CustomPainter {
  double xPos;
  double yPos;

  // The lowest the y coordinate can be without being behind the goal line
  double _lowLimit;

  OpenPainter(this.xPos, this.yPos, this._lowLimit);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Only draw if user taps image
    if (xPos == 500.0 || yPos == 500.0 || yPos < _lowLimit) return;

    // Draw the circle
    canvas.drawCircle(Offset(xPos - 2.5 / 2, yPos - 5 / 2), 5,
        paint1); // Subtrackt radius to get center
  }

  // Redraw when Positions change - Don't redraw if user presses outside of pitch
  @override
  bool shouldRepaint(CustomPainter other) => (yPos >= _lowLimit);
}
