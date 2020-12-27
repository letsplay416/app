import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final pageList = [
      PageModel(
          color: context.theme.accentColor,
          heroImagePath: "assets/onBoarding/1609086107711.png",
          title: Text(
            'Hey',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: context.theme.primaryColor,
              fontSize: 34.0,
            ),
          ),
          body: Text(
            'Fatigué(e) du train-train quotidien ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          iconImagePath: "assets/images/jeton.png"),
      PageModel(
          color: context.theme.primaryColor,
          heroImagePath: "assets/onBoarding/1609086334621.png",
          title: Text(
            'O.M.G',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: context.theme.accentColor,
              fontSize: 34.0,
            ),
          ),
          body: Text(
            "Bienvenue dans le monde où nous faisons de vos rêves une réalité.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          iconImagePath: "assets/images/jeton.png"),
      PageModel(
          color: context.theme.accentColor,
          heroImagePath: "assets/onBoarding/1609086362311.png",
          title: Text("Riche\$\$e",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: context.theme.primaryColor,
                fontSize: 34.0,
              )),
          body: Text(
            "Ici, gloire, trophées, argent ne seront ni virtuels ni imaginaires",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          iconImagePath: "assets/images/jeton.png"),
      PageModel(
          color: context.theme.primaryColor,
          heroImagePath: "assets/onBoarding/1609086376601.png",
          title: Text(
            'Team Work',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: context.theme.accentColor,
              fontSize: 34.0,
            ),
          ),
          body: Text(
              "Faites vous des alliés, car ici, le plus grand piège, c'est la solitude.\n Mais faites gaffes aux traîtres et aux voleurs.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          iconImagePath: "assets/images/jeton.png"),
      PageModel(
          color: context.theme.accentColor,
          heroImagePath: "assets/onBoarding/1609086279883.png",
          title: Text("Game is Money",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: context.theme.primaryColor,
                fontSize: 34.0,
              )),
          body: Text(
            "C'est l'univers où jouer ne sera jamais plus une perte de temps.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          iconImagePath: "assets/images/jeton.png"),
    ];

    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Let's Play!!",
        skipButtonText: "Passer",
        skipButton: Container(),
        pageList: pageList,
        doneButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            shape: StadiumBorder(),
            child: Text("Let's Play !!"),
            onPressed: () => context.pop(),
            color: context.primaryColor.withOpacity(0.8),
          ),
        ),
        onDoneButtonPressed: () => context.pop(),
        onSkipButtonPressed: () => context.pop(),
      ),
    );
  }
}
