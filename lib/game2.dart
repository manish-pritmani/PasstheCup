import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

//import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:passthecup/model/teamobject.dart';
import 'package:passthecup/ongoinggames.dart';
import 'package:passthecup/resultscreen.dart';
import 'package:passthecup/traingle.dart';
import 'package:passthecup/utils.dart';
import 'package:passthecup/welcome.dart';
import 'package:screen/screen.dart';

import 'api.dart';
import 'login.dart';
import 'model/Player.dart';

class GameScreen extends StatefulWidget {
  final FirebaseGameObject firebaseGameObject;

  final bool doubleClose;

  final bool tripleClose;

  GameScreen(this.firebaseGameObject,
      {this.doubleClose = false, this.tripleClose = false});

  @override
  State<StatefulWidget> createState() => _GameScreenState(firebaseGameObject);
}

class _GameScreenState extends State<GameScreen>
    with PortraitStatefulModeMixin<GameScreen>, SingleTickerProviderStateMixin {
  FirebaseGameObject firebaseGameObject;
  bool gameOver;
  String displayMsg;
  List<String> msgArray = [];
  String hitterImageLink = "";
  String pitcherImageLink = "";
  String bgImage = "";

  int lastSnapshotReceivedTime = 0;
  List<int> updateDurationArray = List();
  Timer timer;
  DateTime lastchanged = DateTime.now();
  int currentIndex = 0;
  var ads = [
    "assets/ad1.png",
    "assets/ad2.png",
    "assets/ad3.png",
    "assets/ad4.png",
    "assets/ad5.png"
  ];

  Duration timeSinceLastUpdate = Duration(seconds: 0);

  DateTime initTime = DateTime.now();

  bool dialogVisible = false;

  String homeTeamLogoURL = "";

  String awayTeamLogoURL = "";

  String dueUpHitterID1Link = "";

  String dueUpHitterID2Link = "";

  String dueUpHitterID3Link = "";

  String dueUpHitterID1Name;
  String dueUpHitterID2Name;
  String dueUpHitterID3Name;

  bool runnerOnFirst2Dummy;
  bool runnerOnSecond2Dummy;
  bool runnerOnThird2Dummy;

  double deviceWidth;

  bool small;

  bool showNextThreeHitters = false;

//  MobileAdEvent interstitialAdEvent;

  bool adShown = false;

  bool playShown = false;

  AnimationController animateController;

  List<Map<String, dynamic>> bannerAdDocs = [];
  List<Map<String, dynamic>> interstitialAdDocs = [];

  int lastBannerAdTimeStamp = 0;

  var lastBannerIndex = 0;

  bool showCustomInterstitialAd;

  var interstitailAdIndex = 0;

  int lastHomeRunID = 0;

  _GameScreenState(this.firebaseGameObject);

//  BannerAd _bannerAd;
//  InterstitialAd _interstitialAd;

  var playerFallbackURL =
      'https://s3-us-west-2.amazonaws.com/static.fantasydata.com/headshots/mlb/low-res/10000001.png';

  @override
  void initState() {
    super.initState();
    // Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    animateController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    setState(() {
      gameOver = false;
      displayMsg = "";
      hitterImageLink = "";
      pitcherImageLink = "";
      showNextThreeHitters = false;
      playShown = false;
      lastBannerAdTimeStamp = DateTime.now().millisecondsSinceEpoch;
      showCustomInterstitialAd = false;
    });

    fetchBackgroundImage();
    listenGameObject();
    fetchTeams();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        timeSinceLastUpdate = DateTime.now().difference(
            DateTime.fromMillisecondsSinceEpoch(lastSnapshotReceivedTime));
      });
    });

    initBannerAds();
    fetchInterstitialAds();
  }

  void initBannerAds() async {
    await fetchBannerAds();

    if (!firebaseGameObject.attending) {
//      _bannerAd = createBannerAd()..load();
      //_interstitialAd = createInterstitialAd()..load();
      SchedulerBinding.instance.addPostFrameCallback((_) => afterBuild());
    }
  }

  fetchBannerAds() async {
    var query = await FirebaseFirestore.instance
        .collection('advertisement')
        .where('advertisement_type', isEqualTo: 'Banner')
//        .where('team', isEqualTo: 'Chennai Super Kings')
//        .where('advertisement_date', arrayContains: '19/03/2021')
        .limit(10)
        .get();
    var documents = query.docs;
    setState(() {
      for (var v in documents) {
        bannerAdDocs.add(v.data());
      }
    });
  }

  fetchInterstitialAds() async {
    var query = await FirebaseFirestore.instance
        .collection('advertisement')
        .where('advertisement_type', isEqualTo: 'Interstitial')
//        .where('team', isEqualTo: 'Chennai Super Kings')
//        .where('advertisement_date', arrayContains: '19/03/2021')
        .limit(10)
        .get();
    var documents = query.docs;
    setState(() {
      for (var v in documents) {
        interstitialAdDocs.add(v.data());
      }
    });
  }

//  BannerAd createBannerAd() {
//    return BannerAd(
//      adUnitId: /*"ca-app-pub-8040945760645219/7357443820"*/ BannerAd
//          .testAdUnitId,
//      size: AdSize.banner,
//      targetingInfo: Welcome.targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event $event");
//      },
//    );
//  }
//
//  InterstitialAd createInterstitialAd() {
//    return InterstitialAd(
//      adUnitId: InterstitialAd.testAdUnitId,
//      targetingInfo: Welcome.targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("InterstitialAd event $event");
//        setState(() {
//          interstitialAdEvent = event;
//        });
//      },
//    );
//  }

  createInterstitialAdCustom() {
    var millisecondsSinceEpoch2 = initTime.millisecondsSinceEpoch;
    var millisecondsSinceEpoch3 = DateTime.now().millisecondsSinceEpoch;
    var diff = millisecondsSinceEpoch3 - millisecondsSinceEpoch2;
    bool isGreaterThan10Sec = diff > 10000;
    if (isGreaterThan10Sec) {
      setState(() {
        showCustomInterstitialAd = true;
      });
    }
  }

  void listenGameObject() {
    FirebaseFirestore.instance
        .collection("games")
        .doc(firebaseGameObject.gameCode)
        .snapshots()
        .listen((event) {
      try {
        var map = event.data();
        var encode = jsonEncode(map);
        print("Snapshot Received: " + encode);
        setState(() {
          firebaseGameObject = FirebaseGameObject.fromJson(map);
          if (!isAlreadyAppeared(firebaseGameObject.lastResult.toString())) {
            displayMsg = firebaseGameObject.lastResult.toString();
          }
          lastSnapshotReceivedTime = DateTime.now().millisecondsSinceEpoch;
          updateDurationArray.add(timeSinceLastUpdate.inSeconds);
          runnerOnFirst2Dummy = Random().nextBool();
          runnerOnSecond2Dummy = Random().nextBool();
          runnerOnThird2Dummy = Random().nextBool();
        });
        fetchHitterProfilePicture();
        fetchPitcherProfilePicture();
        fetchDueUpHitter1Picture();
        fetchDueUpHitter2Picture();
        fetchDueUpHitter3Picture();

        if (firebaseGameObject.selectedGame.lastPlay
                .toString()
                .toLowerCase()
                .contains('homerun') ||
            firebaseGameObject.selectedGame.lastPlay
                .toString()
                .toLowerCase()
                .contains('home run') ||
            firebaseGameObject.selectedGame.lastPlay
                .toString()
                .toLowerCase()
                .contains('home')) {
          if (firebaseGameObject.lastPlayID != lastHomeRunID) {
            showHomeRunAnimation();
            setState(() {
              lastHomeRunID = firebaseGameObject.lastPlayID;
            });
          } else {
            print('skipped');
          }
          setState(() {
            displayMsg = firebaseGameObject.selectedGame.lastPlay;
          });
        }

        if (firebaseGameObject.status == -1) {
          openResultScreen();
        }
        print("GAME STATUS: " + firebaseGameObject.status.toString());
        print("GAME ISCLOSED: " +
            firebaseGameObject.selectedGame.isClosed.toString());
        print("GAME STATUS: " +
            firebaseGameObject.selectedGame.status.toString());

        if (firebaseGameObject.selectedGame.status == "Scheduled") {
          showGameNotStartedDialog();
        } else {
          if (dialogVisible) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void openResultScreen() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new ResultScreen(firebaseGameObject);
      },
    ));
  }

  void fetchBackgroundImage() {
    FirebaseFirestore.instance
        .collection("images")
        .doc(firebaseGameObject.selectedGame.homeTeam)
        .get()
        .then((value) {
      var src = value.data()["link"];
      setState(() {
        bgImage = src;
      });
    }).catchError((e) {});
  }

  @override
  void dispose() {
//    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    timer?.cancel();
//    _bannerAd?.dispose();
//    _interstitialAd?.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print(MediaQuery.of(context).size.width.toString() + " width of device");
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width;
      small = deviceWidth <= 670;
    });
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      drawer: buildDrawer(context),
      body: firebaseGameObject == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildBuildSafeArea(),
    );
  }

  void afterBuild() {
    // executes after build is done
//    _bannerAd ??= createBannerAd();
//    var width = MediaQuery.of(context).size.width;
//    var horizontalCenterOffset2 = width / 2 + 200;
//    _bannerAd
//      ..load()
//      ..show(anchorType: AnchorType.top, horizontalCenterOffset: -150);
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        key: const PageStorageKey<String>('pagestore'),
        width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.white.withOpacity(0.88),
        height: MediaQuery.of(context).size.height,
        child: OnGoingGames(
          "InProgress",
          onClick: (gameObject) {
            Utils.doNotRotate = true;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(
                          gameObject,
                        )));
          },
        ),
      ),
    );
  }

  Widget buildBuildSafeArea() {
    return Stack(
      children: [
        Container(child: buildSafeArea()),
        Align(
          child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Image.asset(
                "assets/slider1.png",
                width: 40,
                height: 100,
              )),
          alignment: Alignment.centerLeft,
        ),
        Center(
          child: ZoomIn(
              duration: Duration(milliseconds: 500),
              animate: false,
              manualTrigger: true,
              controller: (controller) => animateController = controller,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/hr.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        "HOMERUN",
                        style: TextStyle(
                            fontSize: 75,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        buildCustomBannerAd(),
        buildCustomInterstitialAd(),
        // Align(
        //   child: getLastSnapshotTimeText(),
        //   alignment: Alignment.center,
        // ),
      ],
    );
  }

  Widget buildCustomBannerAd() {
    if (firebaseGameObject.attending) {
      var src =
          "https://stockbuddyneerajhome.files.wordpress.com/2019/04/kffsivj.png";
      if (bannerAdDocs.length > 0) {
        if (DateTime.now().millisecondsSinceEpoch - lastBannerAdTimeStamp >
            10000) {
          lastBannerIndex++;
          if (lastBannerIndex >= bannerAdDocs.length) {
            lastBannerIndex = 0;
          }
          lastBannerAdTimeStamp = DateTime.now().millisecondsSinceEpoch;
//          createInterstitialAdCustom();
        }
        src = bannerAdDocs[lastBannerIndex]['image'];
      }
      return Positioned(
        child: Container(
          width: 300,
          height: 50,
          color: Colors.white,
          child: Image.network(
            src,
            width: 300,
            fit: BoxFit.cover,
            height: 50,
          ),
        ),
        left: 150,
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildSafeArea() {
    return FadeAnimation(
      1,
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: getBackgroundImage(),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.srcOver)),
        ),
        child: buildColumn(context),
      ),
    );
  }

  ImageProvider<dynamic> getBackgroundImage() {
    if (bgImage == null || bgImage == "") {
      return AssetImage("assets/stadium.jpg");
    } else {
      return NetworkImage(bgImage);
    }
  }

  Widget buildColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 16),
      child: Stack(
        children: <Widget>[
          Align(
            child: getExitButton(),
            alignment: Alignment.topRight,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[getMainRow(context), getBottomRow()],
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  getLastSnapshotTimeText(),
//                  getGameIDText(),
                  //getChannelNameText(),
                  //getPlayID(),
                ],
              ),
            ),
            alignment: Alignment.topLeft,
          ),
//          Align(
//            child: Image.asset(
//              getAdImageName(),
//              width: small ? 200 : 250,
//              height: small ? 30 : 40,
//              fit: BoxFit.fitWidth,
//            ),
//            alignment: Alignment.topCenter,
//          ),
        ],
      ),
    );
  }

  String getAdImageName() {
    var seconds = DateTime.now().difference(lastchanged).inSeconds;
    if (seconds > 15) {
      var i = currentIndex + 1;
      var j = ads.length - 1;
      if (i < j) {
        currentIndex = currentIndex + 1;
      } else {
        currentIndex = 0;
      }
      lastchanged = DateTime.now();
    }
    return ads[currentIndex];
  }

  Padding getBottomRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30),
      child: getLastPlayDescriptionWidget(),
    );
  }

  Widget getCupWidget({bool large = false}) {
    var scoreToShow = firebaseGameObject.cupScore2.toString();
    if (firebaseGameObject.cupScore2 > -10 &&
        firebaseGameObject.cupScore2 < 10) {
      scoreToShow = "0" + firebaseGameObject.cupScore2.toString();
    }
    //scoreToShow = firebaseGameObject.cupScore.toString()+','+firebaseGameObject.cupScore2.toString(); //temporirily added
    return InkWell(
      onTap: () {
        //showHomeRunAnimation();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Stack(
          children: <Widget>[
            Image.asset(
              "assets/Cup_Icon.png",
              width: large ? 100 : 70,
              height: large ? 80 : 50,
            ),
            Positioned(
              top: large ? 25 : 15,
              left: large ? 40 : 27,
              child: Text(
                scoreToShow + "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: large ? 18 : 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showHomeRunAnimation() async {
    animateController.forward();
    await Future.delayed(Duration(seconds: 3));
    animateController.animateTo(0);
  }

  Row getMainRow(BuildContext context) {
    int v = 0;
    int sum = 0;
    firebaseGameObject.players.forEach((element) {
      sum = sum + element.gamescore2;
    });

    v = sum;
    if(firebaseGameObject.cupScore2+sum!=0){
      Vibrate.vibrate();
    }


    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getFieldWidget(),
//        showNextThreeHitters ? getCupWidget(large: true) : SizedBox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getScoreData(),
//            Text(
//              v.toString(),
//              style: TextStyle(color: Colors.white, fontSize: 30),
//            ),
            /* getPlayersRow()*/
            getNewPlayerCarousel()
          ],
        ),
      ],
    );
  }

  Widget getRightWidget() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getPointsAwardedWidget(),
          Padding(
            padding: const EdgeInsets.only(right: 26.0, top: 8),
            child: Text(
              "${firebaseGameObject.lastResult}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  IconButton getExitButton() {
    return IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
//          _interstitialAd?.show();
          Utils().showToast("Are you sure you want to exit the game?", context,
              ok: () {
            Navigator.pop(context);
          }, cancel: true, oktext: "Exit Game");
        });
  }

  Widget getFieldWidget() {
    var imgName = "assets/d___.png";
    var runnerOnFirst2 = firebaseGameObject.selectedGame.runnerOnFirst;
    var runnerOnSecond2 = firebaseGameObject.selectedGame.runnerOnSecond;
    var runnerOnThird2 = firebaseGameObject.selectedGame.runnerOnThird;

    if (firebaseGameObject.simulation) {
      runnerOnFirst2 = true;
      runnerOnSecond2 = true;
      runnerOnThird2 = false;
    }

    if (!showNextThreeHitters) {
      var r1 = runnerOnFirst2 ?? false ? "1" : "_";
      var r2 = runnerOnSecond2 ?? false ? "2" : "_";
      var r3 = runnerOnThird2 ?? false ? "3" : "_";
      imgName = "assets/d$r1$r2$r3.png";
    }
    return Container(
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width * .3,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Image.asset(
            imgName,
            width: 200,
            height: 200,
          ),
          Positioned(
            bottom: 80,
            left: small ? 50 : 70,
            child: Column(
              children: <Widget>[
                getPitcherImage(),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: !showNextThreeHitters,
                  child: Text(
                    firebaseGameObject.selectedGame.currentPitcher == null
                        ? ""
                        : firebaseGameObject.selectedGame.currentPitcher
                            .toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: -10,
            left: small ? 70 : 65,
            child: Column(
              children: <Widget>[
                getHitterImage(),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: !showNextThreeHitters,
                  child: Text(
                    firebaseGameObject.selectedGame.currentHitter == null
                        ? ""
                        : firebaseGameObject.selectedGame.currentHitter
                            .toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showNextThreeHitters,
            child: Positioned(
              top: 50,
              left: 50,
              child: getCupWidget(large: true),
            ),
          )
//          getFieldPlayerWidgetLeft(),
//          getFieldPlayerRightWidget(),
//          getFieldPlayerTopWidget(),
        ],
      ),
    );
  }

  Widget getFieldPlayerTopWidget() {
    bool b = firebaseGameObject.selectedGame.runnerOnSecond;
    if (b == null) {
      b = false;
    }
    return Visibility(
      visible: b,
      child: Positioned(
        top: 35,
        left: 95,
        child: Image.asset(
          "assets/dot.png",
          width: 15,
          height: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getFieldPlayerRightWidget() {
    bool b = firebaseGameObject.selectedGame.runnerOnFirst;
    if (b == null) {
      b = false;
    }
    return Visibility(
      visible: b,
      child: Positioned(
        bottom: 87,
        right: 27,
        child: Image.asset(
          "assets/dot.png",
          width: 15,
          height: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getFieldPlayerWidgetLeft() {
    bool b = firebaseGameObject.selectedGame.runnerOnThird;
    if (b == null) {
      b = false;
    }
    return Visibility(
      visible: b,
      child: Positioned(
        bottom: 87,
        left: 27,
        child: Image.asset(
          "assets/dot.png",
          width: 15,
          height: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getLastPlayDescriptionWidget() {
    print('last result: ' +
        firebaseGameObject.lastResult.toString().toLowerCase());
    List<String> blackListedPlays = [
      "stolen base",
      "caught stealing",
      "wild pitch",
      "passed ball"
    ];
    bool b = displayMsg != "null";
    var lastResultPointsAwarded = firebaseGameObject.lastResultPointsAwarded;
    var contains = blackListedPlays
        .contains(firebaseGameObject.lastResult.toString().toLowerCase());
    if (contains || lastResultPointsAwarded != 0) {
      adShown = false;
      setState(() {
        showNextThreeHitters = false;
        playShown = true;
      });
      var pointsToDisplay = lastResultPointsAwarded.toString();
      if (lastResultPointsAwarded > 0) {
        pointsToDisplay = "+" + lastResultPointsAwarded.toString();
      }
      return Container(
        child: Visibility(
          visible: b,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
              color: getLastPlayWidgetColor(lastResultPointsAwarded),
              child: AutoSizeText(
                displayMsg.toString() + " (" + pointsToDisplay + ")",
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                textAlign: TextAlign.center,
                presetFontSizes: [16, 12, 10],
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    } else {
      if (firebaseGameObject.selectedGame.balls == null &&
          firebaseGameObject.selectedGame.outs == null &&
          firebaseGameObject.selectedGame.strikes == null &&
          firebaseGameObject.selectedGame.inning != null &&
          firebaseGameObject.selectedGame.inning != 9) {
        setState(() {
          showNextThreeHitters = true;
        });
        if (!adShown) {
          if (!firebaseGameObject.attending) {
//            _interstitialAd?.show();
//            _interstitialAd?.dispose();
//            _interstitialAd = createInterstitialAd()..load();
          } else {
            createInterstitialAdCustom();
          }
          adShown = true;
          setState(() {
            playShown = true;
          });
        }
        return Container(
          width: 300,
          child: Visibility(
            visible: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
                color: Colors.blueAccent.withOpacity(0.75),
                child: AutoSizeText(
                  "End of the inning",
                  style: TextStyle(color: Colors.white),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  presetFontSizes: [16, 12, 10],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      } else {
        adShown = false;
        setState(() {
          showNextThreeHitters = false;
          playShown = false;
        });
        return Container(
          width: 300,
          height: 50,
        );
      }
    }
  }

  bool isAlreadyAppeared(String msg) {
    for (String s in msgArray) {
      if (s == msg) {
        return true;
      }
    }
    setState(() {
      if (msg != 'null' && msg.isNotEmpty) {
        msgArray.add(msg);
      }
    });
    return false;
  }

  Color getLastPlayWidgetColor(int lastResultPointsAwarded) {
    if (lastResultPointsAwarded > 0) {
      return Colors.green.withOpacity(0.75);
    } else if (lastResultPointsAwarded < 0) {
      return Colors.redAccent.withOpacity(0.75);
    } else {
      return Colors.blueAccent.withOpacity(0.75);
    }
  }

  Text getChannelNameText() {
    return Text(
      "Channel: ${firebaseGameObject.selectedGame.channel}",
      style: TextStyle(color: Hexcolor("#99FFFFFF"), fontSize: small ? 10 : 10),
    );
  }

  Text getLastSnapshotTimeText() {
    return Text(
      "Last Updated: ${timeSinceLastUpdate.inSeconds.toString()} sec ago\nsimulation:${firebaseGameObject.simulation}",
      //"\nShortest Time: ${getSmallest()} sec"
      //"\nLongest Time: ${getLargest()} sec"
      // "\nAverage Time: ${getAvg()} sec"
      //"\n${updateDurationArray.toString()}",
      textAlign: TextAlign.center,
      style: TextStyle(color: Hexcolor("#99FFFFFF"), fontSize: small ? 10 : 10),
    );
  }

  Text getPlayID() {
    var string = firebaseGameObject.toJson().toString();
    print(string);
    return Text(
      "Last PlayID: ${firebaseGameObject.lastPlayID}",
      //"\nShortest Time: ${getSmallest()} sec"
      //"\nLongest Time: ${getLargest()} sec"
      // "\nAverage Time: ${getAvg()} sec"
      //"\n${updateDurationArray.toString()}",
      style: TextStyle(color: Hexcolor("#99FFFFFF")),
    );
  }

  Text getGameIDText() {
    return Text(
      "Game ID: ${firebaseGameObject.gameCode}",
      style: TextStyle(color: Hexcolor("#99FFFFFF"), fontSize: small ? 12 : 12),
    );
  }

  Widget buildResultWidget() {
    try {
      return Visibility(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            "Last Result: ${firebaseGameObject.lastResult} (${firebaseGameObject.lastResultPointsAwarded})",
            style: TextStyle(color: Colors.white),
          ),
        ),
        visible: true,
      );
    } catch (e) {
      print(e);
      return SizedBox();
    }
  }

  Container getScoreData() {
    try {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            getPointsColumn(),
            SizedBox(
              height: 20,
            ),
            /*simulation ? getBSO() : */ getBSOLive(),
            SizedBox(
              height: 0,
            ),
            //getPointsTable(),
//            getLastPlayDescriptionWidget()
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Container(child: Text("e.message"));
    }
  }

//  Row getCurrentPlayerInfoWidget() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        FadeAnimation(
//            1.3,
//            Text(
//              "4.",
//              style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 20,
//                  fontWeight: FontWeight.w600),
//            )),
//        SizedBox(
//          width: 10,
//        ),
//        FadeAnimation(
//            1.3,
//            CircleAvatar(
//              maxRadius: 15,
//              backgroundImage: AssetImage("assets/girl.png"),
//            )),
//        SizedBox(
//          width: 10,
//        ),
//        FadeAnimation(
//            1.3,
//            Text(
//              "Ayush Mehre",
//              style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 18,
//                  fontWeight: FontWeight.w400),
//            )),
//      ],
//    );
//  }

//  Container getCurrentPlayersInfo() {
//    return Container(
//      width: MediaQuery.of(context).size.width * .28,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          IconButton(
//              icon: Icon(
//                Icons.close,
//                color: Colors.white,
//              ),
//              onPressed: () {
//                Utils().showToast(
//                    "Are you sure you want to exit the game?", context, ok: () {
//                  Navigator.pop(context);
//                }, cancel: true, oktext: "Exit Game");
//              }),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 10),
//                child: Container(
//                    padding: EdgeInsets.only(top: 3, left: 0),
//                    child: Container(
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(0),
//                            color: Colors.transparent),
//                        child: Column(
//                          children: <Widget>[getHitterImage()],
//                        ))),
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "Current Hitter",
//                    style: TextStyle(
//                        color: Colors.white60,
//                        fontSize: 14,
//                        fontWeight: FontWeight.w400),
//                  ),
//                  SizedBox(
//                    width: 100,
//                    child: Text(
//                      firebaseGameObject == null || firebaseGameObject == null
//                          ? "Loading..."
//                          : getBatterNameText(),
//                      softWrap: true,
//                      overflow: TextOverflow.fade,
//                      maxLines: 5,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 14,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                ],
//              )
//            ],
//          ),
//          SizedBox(
//            height: 10,
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 10),
//                child: Container(
//                    padding: EdgeInsets.only(top: 3, left: 3),
//                    child: Container(
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Colors.transparent),
//                        child: Column(
//                          children: <Widget>[getPitcherImage()],
//                        ))),
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "Current Pitcher",
//                    style: TextStyle(
//                        color: Colors.white60,
//                        fontSize: 14,
//                        fontWeight: FontWeight.w400),
//                  ),
//                  SizedBox(
//                    width: 100,
//                    child: Text(
//                      firebaseGameObject == null
//                          /*||
//                          firebaseGameObject.gameProgress.currentPitcher == null*/
//                          ? "Loading..."
//                          : getPitcherNAmeText(),
//                      softWrap: true,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 14,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                ],
//              )
//            ],
//          ),
//        ],
//      ),
//    );
//  }

  Widget getPitcherImage() {
    if (pitcherImageLink != null && pitcherImageLink.isNotEmpty) {
      return Image.network(
        showNextThreeHitters ? playerFallbackURL : pitcherImageLink,
        width: 50,
        height: 50,
      );
    } else {
      return SizedBox(
        width: 50,
        height: 50,
      );
    }
  }

  Widget getHitterImage() {
    if (hitterImageLink != null && hitterImageLink.isNotEmpty) {
      return Image.network(
        showNextThreeHitters ? playerFallbackURL : hitterImageLink,
        width: 50,
        height: 50,
      );
    } else {
      return SizedBox(
        width: 50,
        height: 50,
      );
    }
  }

  String getBatterNameText() {
    return firebaseGameObject.selectedGame.currentHitter.toString();
  }

  String getPitcherNAmeText() {
    return firebaseGameObject.selectedGame.currentPitcher.toString();
  }

  Widget getPlayersRow() {
    var players = firebaseGameObject.players;
    var playersWithCurrentPlayerAtFirst = List<Player>();
    var playersBeforeCurrentPlayer = List<Player>();
    var playersAfterCurrentPlayer = List<Player>();

    //getting all the players before currentActivePlayer
    for (int i = 0; i < firebaseGameObject.currentActivePlayer; i++) {
      playersBeforeCurrentPlayer.add(players[i]);
    }

    //getting all the players after currentActivePlayer
    for (int i = firebaseGameObject.currentActivePlayer;
        i < players.length;
        i++) {
      playersAfterCurrentPlayer.add(players[i]);
    }

    playersWithCurrentPlayerAtFirst.addAll(playersAfterCurrentPlayer);
    playersWithCurrentPlayerAtFirst.addAll(playersBeforeCurrentPlayer);

    List<Widget> playersW = List();
    //playersW.add(getCupWidget());
    var count = 0;
    for (Player player in playersWithCurrentPlayerAtFirst) {
      playersW.add(getPlayerWidget(player, index: count));
      count++;
    }

    double width2 = deviceWidth <= 670 ? 200 : 300;
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: playersW,
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget getPlayersInLobby() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: firebaseGameObject.players.length,
        itemBuilder: (context, index) {
          return getPlayerWidgetLobby(firebaseGameObject.players[index],
              active: firebaseGameObject.players[index].host);
        },
      ),
    );
  }

  Widget getPlayerWidgetLobby(Player player, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: active ? 17 : 15,
            backgroundColor: Colors.redAccent,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: networkImage(player),
            ),
          ),
          Text(
            player.name.substring(0, player.name.indexOf(" ")),
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget getDueUpHitterWidget(int index) {
    var label = "";
    var src = "";
    var playerName = "";
    switch (index) {
      case 1:
        label = "On Deck";
        src = dueUpHitterID1Link;
        playerName = dueUpHitterID1Name ?? "";
        break;
      case 2:
        label = "In the Hole";
        src = dueUpHitterID2Link;
        playerName = dueUpHitterID2Name ?? "";
        break;
      case 3:
        label = "  3rd Up  ";
        src = dueUpHitterID3Link;
        playerName = dueUpHitterID3Name ?? "";
        break;
    }
    return Opacity(
      opacity: showNextThreeHitters ? 1 : 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        margin: EdgeInsets.only(bottom: 5),
        color: index <= 3 ? Colors.black.withOpacity(0.5) : Colors.transparent,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Image.network(
              src ?? playerFallbackURL,
              width: 35,
              height: 35,
            ),
            Text(
              playerName.isNotEmpty ? playerName : "Player",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPlayerWidget(Player player, {int index}) {
    var playerName = player.name;
    if (playerName.contains(" ")) {
      playerName = player.name.substring(0, player.name.indexOf(" "));
    }
    double radius2 = small ? 20 : 25;
    double highlighted = small ? 22 : 27;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          index == 0
              ? (showNextThreeHitters
                  ? getDueUpHitterWidget(index + 1)
                  : getCupWidget())
              : getDueUpHitterWidget(index + 1),
          CircleAvatar(
            radius: index == 0 ? highlighted : radius2,
            backgroundColor: Colors.yellow,
            child: Stack(
              children: [
                Align(
                  child: CircleAvatar(
                    radius: radius2,
                    backgroundImage: networkImage(player),
                  ),
                  alignment: Alignment.center,
                ),
                Align(
                  child: index == 0 ? null : null,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          Text(
            playerName,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            color: Colors.black.withOpacity(0.6),
            child: Text(
              "${player.gamescore2}",
              style: TextStyle(
                  color: getColorAccordingToScore(player.gamescore2),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color getColorAccordingToScore(int gamescore) {
    if (gamescore < 0) {
      return Colors.redAccent;
    } else if (gamescore > 0) {
      return Colors.green;
    }
    return Colors.blueAccent;
  }

  NetworkImage networkImage(Player player) {
    return NetworkImage(
        "https://ui-avatars.com/api/?name=${player.name}&bold=true&background=808080&color=ffffff");
  }

  Widget getPointsColumn() {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  getImageWidget(awayTeamLogoURL),
//                  Text(
//                    firebaseGameObject.selectedGame.awayTeam,
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 14,
//                        color: Colors.white),
//                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              firebaseGameObject.selectedGame.awayTeamRuns
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Utils().getBlue()),
                    child: Column(
                      children: <Widget>[
                        Text(
                          getCurrentInningNumber(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
              Column(
                children: <Widget>[
                  getImageWidget(homeTeamLogoURL),
//                  Text(
//                    firebaseGameObject.selectedGame.homeTeam,
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 14,
//                        color: Colors.white),
//                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              firebaseGameObject.selectedGame.homeTeamRuns
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  /* Text(
                        "Balls",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),*/
                ],
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      print(e);
      return Text(e.toString());
    }
  }

  Widget getVersusWidget() {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    firebaseGameObject.selectedGame.awayTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                firebaseGameObject.selectedGame.awayTeam
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Utils().getBlue()),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "VS",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
              ),
              Column(
                children: <Widget>[
                  Text(
                    firebaseGameObject.selectedGame.homeTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                firebaseGameObject.selectedGame.homeTeam
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                  /* Text(
                        "Balls",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),*/
                ],
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      print(e);
      return Text(e.toString());
    }
  }

  String getCurrentInningNumber() {
    try {
//      var play = firebaseGameObject.currentInningNumber[currentPlay];
      int number = firebaseGameObject.selectedGame.inning;
      var inningHalf =
          firebaseGameObject.selectedGame.inningHalf == "T" ? "▲" : "▼";
      if (number == 1) {
        return number.toString() + "st $inningHalf";
      } else if (number == 2) {
        return number.toString() + "nd $inningHalf";
      } else if (number == 3) {
        return number.toString() + "rd $inningHalf";
      } else {
        return number.toString() + "th $inningHalf";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  getPointsTable() {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: getInningsUptoNow(),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white),
              top: BorderSide(color: Colors.white),
              left: BorderSide(color: Colors.white),
              right: BorderSide(color: Colors.white),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.white),
                    top: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                  )),
                  child: Row(
                    children: getInningsScoreUptoNowTeamAway(),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.white),
                    top: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                  )),
                  child: Row(
                    children: getInningsScoreUptoNowHomeTeam(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getInningsScoreUptoNowTeamAway() {
    List<Widget> widgets = List<Widget>();
    widgets.add(getTextForTable(firebaseGameObject.selectedGame.awayTeam,
        wide: true, bold: true));
    for (int i = 0; i < 9; i++) {
      if (i <= firebaseGameObject.selectedGame.inning) {
        try {
          var string = firebaseGameObject.selectedGame.innings[i].awayTeamRuns
              .toString();
          widgets.add(getTextForTable(string));
        } catch (e) {
          print(e);
          widgets.add(getTextForTable(""));
        }
      }
      /*else if (i == currentInnings) {
//          if (gameObjectPlayByPlay.plays[currentPlay].inningHalf == "T") {
//            widgets.add(getTextForTable(
//                gameObjectPlayByPlay.game.innings[i].awayTeamRuns.toString()));
//          } else {
//            widgets.add(getTextForTable(
//                gameObjectPlayByPlay.game.innings[i].awayTeamRuns.toString()));
//          }
          widgets.add(getTextForTable(""));
        } */
      else {
        widgets.add(getTextForTable(""));
      }
    }
    return widgets;
  }

  List<Widget> getInningsScoreUptoNowHomeTeam() {
    List<Widget> widgets = List<Widget>();
    try {
      widgets.add(getTextForTable(firebaseGameObject.selectedGame.homeTeam,
          wide: true, bold: true));
      for (int i = 0; i < 9; i++) {
        if (i <= firebaseGameObject.selectedGame.inning) {
          try {
            var string = firebaseGameObject.selectedGame.innings[i].homeTeamRuns
                .toString();
            if (string != "null") {
              widgets.add(getTextForTable(string));
            } else {
              widgets.add(getTextForTable(""));
            }
          } catch (e) {
            print(e);
            widgets.add(getTextForTable(""));
          }
        }
        /*else if (i == currentInnings) {
//          if (gameObjectPlayByPlay.plays[currentPlay].inningHalf == "B") {
//            widgets.add(getTextForTable(
//                gameObjectPlayByPlay.game.innings[i].homeTeamRuns.toString()));
//          } else {
//            widgets.add(getTextForTable(""));
          widgets.add(getTextForTable(""));
//          }
        }*/
        else {
          widgets.add(getTextForTable(""));
        }
      }
    } catch (e) {
      print(e);
    }
    return widgets;
  }

  List<Widget> getInningsUptoNow() {
    return <Widget>[
      getTextForTable("Innings", wide: true, bold: true),
      getTextForTable("1"),
      getTextForTable("2"),
      getTextForTable("3"),
      getTextForTable("4"),
      getTextForTable("5"),
      getTextForTable("6"),
      getTextForTable("7"),
      getTextForTable("8"),
      getTextForTable("9"),
    ];
  }

  Widget getTextForTable(String text, {bool wide = false, bool bold = false}) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: bold ? FontWeight.bold : null,
            color: Colors.white,
            fontSize: 13),
      ),
      height: 23,
      width: wide ? 50 : 25,
    );
  }

  Widget getBSOLive() {
    try {
      var ballsCount = //firebaseGameObject.latestPlay['Balls'];
          firebaseGameObject.selectedGame
              .balls; //change back to original code when original game starts
      if (ballsCount != null && ballsCount > 3) {
        ballsCount = 3;
      }
      var strikesCount =// firebaseGameObject.latestPlay['Strikes'];
          firebaseGameObject.selectedGame
              .strikes; //change back to original code when original game starts
      if (strikesCount != null && strikesCount > 2) {
        strikesCount = 2;
      }

      var outs = //firebaseGameObject.latestPlay['Outs'];
          firebaseGameObject.selectedGame
              .outs; //change back to original code when original game starts
      //playShown = false; // remove this line when original game starts
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          getDotView("BALL", playShown ? 0 : ballsCount),
          SizedBox(
            width: 30,
          ),
          getDotView("STRIKE", playShown ? 0 : strikesCount),
          SizedBox(
            width: 30,
          ),
          getDotView("OUT", playShown ? 0 : outs),
        ],
      );
    } catch (e) {
      print(e);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          getDotView("BALL", 0),
          SizedBox(
            width: 30,
          ),
          getDotView("STRIKE", 0),
          SizedBox(
            width: 30,
          ),
          getDotView("OUT", 0),
        ],
      );
    }
  }

  Column getDotView(String title, int count) {
    if (count == null) {
      count = 0;
    }
    String dots = "";
    for (int i = 0; i < count; i++) {
      dots = dots + "⚪ ";
    }
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 0,
        ),
        Text(dots,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget getPointsAwardedWidget() {
    var pointsAwarded = firebaseGameObject.lastResultPointsAwarded;
    return Container(
      margin: EdgeInsets.only(right: 0),
      width: 54,
      height: 54,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              pointsAwarded.toString(),
              style: TextStyle(
                color: pointsAwarded == 0
                    ? Colors.transparent
                    : pointsAwarded >= 0
                        ? Colors.black
                        : Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
//            Text(
//              getPointText(pointsAwarded),
//              style: TextStyle(
//                fontSize: 12.0,
//                color: pointsAwarded >= 0 ? Colors.black : Colors.white,
//                fontWeight: FontWeight.bold,
//              ),
//              textAlign: TextAlign.center,
//            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(200),
        ),
        color: getColorByPointsAwarded(pointsAwarded),
      ),
    );
  }

  String getPointText(int pointsAwarded) {
    if ((pointsAwarded == 1 || pointsAwarded == -1)) {
      return "Point";
    } else {
      return "Points";
    }
  }

  Color getColorByPointsAwarded(int pointsAwarded) {
    if (pointsAwarded > 0) {
      return Colors.greenAccent;
    } else if (pointsAwarded < 0) {
      return Colors.redAccent;
    } else {
      return Colors.white.withOpacity(0.0);
    }
  }

  void fetchHitterProfilePicture() {
    var currentHitterID2 = firebaseGameObject.selectedGame.currentHitterID;
    if (firebaseGameObject.simulation) {
      currentHitterID2 = 10000005;
    }
    API().fetchPlayerImage(currentHitterID2).then((value) {
      try {
        setState(() {
          hitterImageLink = value;
        });
      } on Exception catch (e) {
        print(e.toString());
      }
      return null;
    });
  }

  void fetchTeams() {
    API().fetchTeamImage().then((value) {
      for (TeamObject team in value) {
        if (firebaseGameObject.selectedGame.awayTeamID == team.teamID) {
          setState(() {
            awayTeamLogoURL = team.wikipediaWordMarkUrl;
          });
        }
        if (firebaseGameObject.selectedGame.homeTeamID == team.teamID) {
          homeTeamLogoURL = team.wikipediaWordMarkUrl;
        }
      }
      return null;
    });
  }

  void fetchPitcherProfilePicture() {
    var currentPitcherID2 = firebaseGameObject.selectedGame.currentPitcherID;
    if (firebaseGameObject.simulation) {
      currentPitcherID2 = 10000016;
    }
    API().fetchPlayerImage(currentPitcherID2).then((value) {
      setState(() {
        pitcherImageLink = value;
      });
      return null;
    });
  }

  void fetchDueUpHitter1Picture() {
    var dueUpHitterID12 = firebaseGameObject.selectedGame.dueUpHitterID1;
    if (firebaseGameObject.simulation) {
      dueUpHitterID12 = 10000058;
    }
    API().fetchPlayerProfile(dueUpHitterID12).then((value) {
      try {
        setState(() {
          dueUpHitterID1Link = value.photoUrl;
          dueUpHitterID1Name = value.lastName;
        });
      } on Exception catch (e) {
        print(e.toString());
      }
      return null;
    });
  }

  void fetchDueUpHitter2Picture() {
    var dueUpHitterID22 = firebaseGameObject.selectedGame.dueUpHitterID2;
    if (firebaseGameObject.simulation) {
      dueUpHitterID22 = 10000070;
    }
    API().fetchPlayerProfile(dueUpHitterID22).then((value) {
      setState(() {
        dueUpHitterID2Link = value.photoUrl;
        dueUpHitterID2Name = value.lastName;
      });
      return null;
    });
  }

  void fetchDueUpHitter3Picture() {
    var dueUpHitterID32 = firebaseGameObject.selectedGame.dueUpHitterID3;
    if (firebaseGameObject.simulation) {
      dueUpHitterID32 = 10000193;
    }
    API().fetchPlayerProfile(dueUpHitterID32).then((value) {
      setState(() {
        dueUpHitterID3Link = value.photoUrl;
        dueUpHitterID3Name = value.lastName;
      });
      return null;
    });
  }

  Widget getImageWidget(String url) {
    if (url.endsWith("png")) {
      return Image.network(
        url,
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      );
    } else {
//      return Container();
      return SvgPicture.network(
        url,
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      );
    }
  }

  showQDialog() {
//    showGeneralDialog(
//      barrierLabel: "Barrier",
//      barrierDismissible: true,
//      barrierColor: Colors.black.withOpacity(0.7),
//      transitionDuration: Duration(milliseconds: 200),
//      context: context,
//      pageBuilder: (_, __, ___) {
//        return Align(
//          alignment: Alignment.bottomRight,
//          child: GestureDetector(
//            onTap: () {
//              Navigator.pop(context);
//            },
//            child: Scaffold(
//              backgroundColor: Colors.redAccent,
//              body: Container(
//                child: Stack(
//                  children: <Widget>[],
//                ),
//              ),
//            ),
//          ),
//        );
//      },
//    );
  }

  int getSmallest() {
    int smallest = 1000000;
    updateDurationArray.removeWhere((element) => element == 0);

    updateDurationArray = updateDurationArray.toSet().toList();

    for (int i in updateDurationArray) {
      if (i < smallest) {
        smallest = i;
      }
    }
    return smallest == 1000000 ? 0 : smallest;
  }

  int getLargest() {
    int largest = 0;
    for (int i in updateDurationArray) {
      if (i > largest) {
        largest = i;
      }
    }
    return largest;
  }

  int getAvg() {
    int sum = 0;
    for (int i in updateDurationArray) {
      try {
        sum += updateDurationArray[i];
      } catch (e) {
        print(e);
      }
    }
    var d = sum / updateDurationArray.length;
    try {
      return d.round();
    } catch (e) {
      return 0;
    }
  }

  void showGameNotStartedDialog() async {
    if (dialogVisible) {
      Navigator.pop(context);
    }
    dialogVisible = true;
    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () {},
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.75,
              child: getGameInfoWidget(),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget getGameInfoWidget() {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Please Wait For the Game to Begin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                )),
            getVersusWidget(),
            getGameTimeText(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getChannelInfor(),
                getWeatherInfo(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                firebaseGameObject.players.length == 1
                    ? "${firebaseGameObject.players.length} Player Joined"
                    : "${firebaseGameObject.players.length} Players Joined",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: getPlayersInLobby(),
//            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.black26),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
//                if (widget.doubleClose) {
////                  Navigator.pop(context);
//                }
//                if (widget.tripleClose) {
//                  Navigator.pop(context);
////                  Navigator.pop(context);
//                }
              },
              child: Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text getWeatherInfo() {
    return Text(
      "Weather: ${firebaseGameObject.selectedGame.forecastDescription}",
      style: TextStyle(
          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Text getChannelInfor() {
    return Text(
      "Channel: ${firebaseGameObject.selectedGame.channel}",
      style: TextStyle(
          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget getGameTimeText() {
    var dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var dateTime = firebaseGameObject.selectedGame.dateTime;
    var parsedDate = dateFormat.parse(dateTime);
    var dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        "Game Time: ${dateFormat2.format(parsedDate)}",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget getNewPlayerCarousel() {
    var players = firebaseGameObject.players;
    var playersWithCurrentPlayerAtFirst = List<Player>();
    var playersBeforeCurrentPlayer = List<Player>();
    var playersAfterCurrentPlayer = List<Player>();

    //getting all the players before currentActivePlayer
    for (int i = 0; i < firebaseGameObject.currentActivePlayer; i++) {
      playersBeforeCurrentPlayer.add(players[i]);
    }

    //getting all the players after currentActivePlayer
    for (int i = firebaseGameObject.currentActivePlayer;
        i < players.length;
        i++) {
      playersAfterCurrentPlayer.add(players[i]);
    }

    playersWithCurrentPlayerAtFirst.addAll(playersAfterCurrentPlayer);
    playersWithCurrentPlayerAtFirst.addAll(playersBeforeCurrentPlayer);

    List<Widget> playersW = List();
    //playersW.add(getCupWidget());
    var count = 0;
    for (Player player in playersWithCurrentPlayerAtFirst) {
      playersW.add(getPlayerWidget(player, index: count));
      count++;
    }

    double width2 = deviceWidth <= 670 ? 200 : 300;

    return SizedBox(
        width: 300,
        height: 165,
        child: CarouselSlider.builder(
          options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: false,
            viewportFraction: 1,
          ),
          itemCount: (playersW.length / 2).round(),
          itemBuilder: (context, index, realIdx) {
            final int first = index * 2;
            final int second = first + 1;
            final int third = second + 1;
            return Row(
              children: [first, second, third].map((idx) {
                if (idx < playersW.length) {
                  return SizedBox(width: 100, child: playersW[idx]);
                } else {
                  return SizedBox();
                }
                // return Expanded(
                //   flex: 1,
                //   child: Container(
                //     margin: EdgeInsets.symmetric(horizontal: 10),
                //     child: Image.network(
                //         'https://www.attendit.net/images/easyblog_shared/July_2018/7-4-18/b2ap3_large_totw_network_profile_400.jpg',
                //         fit: BoxFit.cover),
                //   ),
                // );
              }).toList(),
            );
          },
        ));
  }

  buildCustomInterstitialAd() {
    if (showCustomInterstitialAd) {
      return Stack(
        children: [
          Container(
            color: Colors.white,
            child: Image.network(
              interstitialAdDocs[interstitailAdIndex]['image'],
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  showCustomInterstitialAd = false;
                  initTime = DateTime.now();
                  //adShown = false;
                  interstitailAdIndex++;
                  if (interstitailAdIndex >= interstitialAdDocs.length) {
                    interstitailAdIndex = 0;
                  }
                });
              },
              child: Text('Close Ad'),
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}

//Widget getEmptyArea(BuildContext context) {
//  return Container(
//    alignment: Alignment.center,
//    width: MediaQuery.of(context).size.width * .23,
//  );
//}

mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    if (!Utils.doNotRotate) {
      _enableRotation();
    } else {
      Utils.doNotRotate = false;
    }
    super.dispose();
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
