import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:passthecup/ProfileStats.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/authentication.dart';
import 'package:passthecup/gameid.dart';
import 'package:passthecup/mygames.dart';
import 'package:passthecup/scoreBoard.dart';
import 'package:passthecup/todaysgamescreen.dart';
import 'package:passthecup/utils.dart';
import 'package:share/share.dart';


class Welcome extends StatefulWidget {
  static const String testDevice = '708D3F24894BE8D6D31865513C6844A4';
//  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ? <String>[testDevice] : null,
//    keywords: <String>['mlb', 'baseball', 'sports'],
//    contentUrl: 'http://foo.com/bar.html',
//    childDirected: true,
//    nonPersonalizedAds: true,
//  );

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;
  bool isSignedIn = false;
  String gamerImage;
  DocumentSnapshot firebaseUserObject;
  Color borderColor;
  StreamSubscription<DocumentSnapshot> listen;
//  InterstitialAd _interstitialAd;

  //Todo : check if authenticated
  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  //Todo : get user details
  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
        this.gamerImage = user.photoURL;
      });
      FirebaseFirestore.instance
          .collection("user")
          .doc(user.email)
          .get()
          .then((value) {
        setState(() {
          firebaseUserObject = value;
        });
        return null;
      });
    } else {
      Utils().showToast("UserObject null", context);
    }
    print(
        "${user.displayName} is the gamer name with profile image url ${user.photoURL}");

    listen = FirebaseFirestore.instance
        .collection("user")
        .doc(user.email)
        .snapshots()
        .listen((event) {
      setState(() {
        firebaseUserObject = event;
      });
    });
  }

  //TODO: Implement logout button somewhere in welcome screen
  signout() async {
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
    await Authentication.signOut(context: context);
//   Phoenix.rebirth(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen?.cancel();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
    setState(() {
      borderColor = Colors.transparent;
    });

//    FirebaseAdMob.instance
//        .initialize(appId: "ca-app-pub-8040945760645219~6638709781");
//
//    RewardedVideoAd.instance.listener =
//        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//      print("RewardedVideoAd event $event");
//      if (event == RewardedVideoAdEvent.rewarded) {
//        var email = firebaseUserObject.data()["email"];
//        FirebaseFirestore.instance
//            .collection("user")
//            .doc(email)
//            .set({"score": 50}, SetOptions(merge: true));
//      }
//    };

    createRewardedVideoAds();

    /* Firestore.instance.collection("games").where("selectedGame.Status", isEqualTo: "InProgress").getDocuments().then((value) {
      List<DocumentSnapshot> documents = value.documents;
      for(DocumentSnapshot snapshot in documents){
        snapshot.reference.setData({"selectedGame": {"Status": "Final"}}, merge: true);
      }
      return null;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUserObject != null) {
      var data = firebaseUserObject.data();
      var score = 0;
      if (data!=null) {
         score = data["score"];
      }else{
        score = 0;
      }
      var name = 'Ayush';
      var email = 'ayushmehre@gmail.com';
      name = user.displayName;
      email = user.email;
      String hex = "808080";
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Utils().getBGColor(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Utils().getBGColor(),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  "Your Points💰: ${score}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            )
          ],
//          leading: IconButton(
//            onPressed: () {
//              Navigator.pop(context);
//            },
//            icon: Icon(
//              Icons.arrow_back_ios,
//              size: 20,
//              color: Colors.transparent,
//            ),
//          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [CircleAvatar(radius: 20, child: getAvatarWidget(hex),), SizedBox(height: 8,),Text(name), Text(email)],
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: BoxDecoration(color: Colors.grey[300]),
              ),
//              ListTile(
//                title: Text('Profile'),
//                onTap: (){
//                  Navigator.push(context, MaterialPageRoute(builder: (c) {
//                    return ProfileStatsPage(page:0);
//                  }));
//                },
//              ),
//              ListTile(
//                title: Text('Stats'),
//                onTap: (){
//                  Navigator.push(context, MaterialPageRoute(builder: (c) {
//                    return ProfileStatsPage(page:1);
//                  }));
//                },
//              ),
              ListTile(
                title: Text('Scoring Settings'),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return ScoreBoard();
                  }));
                },
              ),
              Divider(),
              ListTile(
                title: Text('How to Play'),
                onTap: (){
                  open("https://www.sportsaddictgames.com/sports-addict-games/how-to-play");
                },
              ),
              ListTile(
                title: Text('Privacy Policy'),
                onTap: (){
                  open("https://www.sportsaddictgames.com/sports-addict-games/privacy-policy");
                },
              ),
              ListTile(
                title: Text('EULA'),
                onTap: () async{
                  open("https://www.sportsaddictgames.com/sports-addict-games/eula");
                },
              ),
            ],
          ),
        ),
        body: user == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildContainer(context),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  open(url){
    FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }



  Widget buildContainer(BuildContext context) {
    Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    String hex = "808080"; // color.value.toRadixString(16).substring(2);
    var name = 'null';
    if (firebaseUserObject.data()!=null) {
      name = firebaseUserObject.data()["name"];
    }
    return Stack(
      children: <Widget>[
        Align(
          child: FadeAnimation(
              1.2,
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/people.png'),
                        fit: BoxFit.cover)),
              )),
          alignment: Alignment.bottomCenter,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getAvatarWidget(hex),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
//                    getAvatar(),
                          FadeAnimation(
                              1,
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              )),
                          FadeAnimation(
                            1,
                            Text(
                              "${name == null ? user.email : name}"
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  getJoinGameButton(context),
                  getCreateGameButton(context),
                  getMyGamesButton(),
                  // getScoreBoardButton(),
                  //getProfileStatsButton(),
                  getInviteFriendsButton(),
                  getSignoutButton(),
                ],
              ),
            ],
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "V.1.4.2",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          alignment: Alignment.bottomRight,
        )
      ],
    );
  }

  FadeAnimation getProfileStatsButton() {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return ProfileStatsPage();
                }));
              },
              color: Utils().getBlue(),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Profile & Stats",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  FadeAnimation getScoreBoardButton() {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return ScoreBoard();
                }));
              },
              color: Utils().getBlue(),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Scoreboard",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  FadeAnimation getSignoutButton() {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: signout,
              color: Utils().getBlue(),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Signout",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  FadeAnimation getMyGamesButton() {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => MyGamesScreen()));
              },
              color: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "My Games",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  FadeAnimation getInviteFriendsButton() {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                Share.share(
                    'Download the PassTheCup App from AppStore: https://apps.apple.com/in/app/facebook/id284882215');
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => Invite()));
              },
              color: Utils().getBlue(),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Invite Friends",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  FadeAnimation getCreateGameButton(BuildContext context) {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                var data2 = firebaseUserObject.data();
                var data = data2["score"];
                data = 50;
                if (data > 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TodaysGameScreen()));
                } else {
                  //RewardedVideoAd.instance.show();
                  createRewardedVideoAds();
                }
              },
              color: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Create Game",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  FadeAnimation getJoinGameButton(BuildContext context) {
    return FadeAnimation(
        1.4,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  top: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                )),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                if (firebaseUserObject.data()["score"] > 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GameId()));
                } else {
                  //RewardedVideoAd.instance.show();
                  createRewardedVideoAds();
                }
              },
              color: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Join Game",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ));
  }

  void createRewardedVideoAds() {
    //MobileAds.instance.initialize();
//    RewardedVideoAd.instance.load(
//        adUnitId: RewardedVideoAd.testAdUnitId,
//        targetingInfo: Welcome.targetingInfo);
  }

  FadeAnimation getAvatarWidget(String hex) {
    var name = 'null';

    if (firebaseUserObject.data()!=null) {
      name = firebaseUserObject.data()["name"];
    }
    return FadeAnimation(
        1,
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              "https://ui-avatars.com/api/?name=$name&bold=true&background=$hex&color=ffffff"),
        ));
  }

  FadeAnimation getAvatar() {
    return FadeAnimation(
        1,
        CircleAvatar(
          backgroundImage: user.photoURL != null
              ? NetworkImage("${user.photoURL}")
              : AssetImage('asset/index.png'),
        ));
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
