import 'package:passthecup/model/gameObjectPlaybyPlay.dart';

class GameObject {
  int gameID;
  int season;
  int seasonType;
  String status;
  String day;
  String dateTime;
  String awayTeam;
  String homeTeam;
  int awayTeamID;
  int homeTeamID;
  int rescheduledGameID;
  int stadiumID;
  String channel;
  int inning;
  String inningHalf;
  int awayTeamRuns;
  int homeTeamRuns;
  int awayTeamHits;
  int homeTeamHits;
  int awayTeamErrors;
  int homeTeamErrors;
  int winningPitcherID;
  int losingPitcherID;
  int savingPitcherID;
  int attendance;
  int awayTeamProbablePitcherID;
  int homeTeamProbablePitcherID;
  int outs;
  int balls;
  int strikes;
  int currentPitcherID;
  int currentHitterID;
  int awayTeamStartingPitcherID;
  int homeTeamStartingPitcherID;
  int currentPitchingTeamID;
  int currentHittingTeamID;
  double pointSpread;
  double overUnder;
  int awayTeamMoneyLine;
  int homeTeamMoneyLine;
  int forecastTempLow;
  int forecastTempHigh;
  String forecastDescription;
  int forecastWindChill;
  int forecastWindSpeed;
  int forecastWindDirection;
  int rescheduledFromGameID;
  bool runnerOnFirst;
  bool runnerOnSecond;
  bool runnerOnThird;
  String awayTeamStartingPitcher;
  String homeTeamStartingPitcher;
  String currentPitcher;
  String currentHitter;
  String winningPitcher;
  String losingPitcher;
  String savingPitcher;
  int dueUpHitterID1;
  int dueUpHitterID2;
  int dueUpHitterID3;
  int globalGameID;
  int globalAwayTeamID;
  int globalHomeTeamID;
  int pointSpreadAwayTeamMoneyLine;
  int pointSpreadHomeTeamMoneyLine;
  String lastPlay;
  bool isClosed;
  String updated;
  String gameEndDateTime;
  int homeRotationNumber;
  int awayRotationNumber;
  bool neutralVenue;
  List<Innings> innings;

  GameObject(
      {this.gameID,
        this.season,
        this.seasonType,
        this.status,
        this.day,
        this.dateTime,
        this.awayTeam,
        this.homeTeam,
        this.awayTeamID,
        this.homeTeamID,
        this.rescheduledGameID,
        this.stadiumID,
        this.channel,
        this.inning,
        this.inningHalf,
        this.awayTeamRuns,
        this.homeTeamRuns,
        this.awayTeamHits,
        this.homeTeamHits,
        this.awayTeamErrors,
        this.homeTeamErrors,
        this.winningPitcherID,
        this.losingPitcherID,
        this.savingPitcherID,
        this.attendance,
        this.awayTeamProbablePitcherID,
        this.homeTeamProbablePitcherID,
        this.outs,
        this.balls,
        this.strikes,
        this.currentPitcherID,
        this.currentHitterID,
        this.awayTeamStartingPitcherID,
        this.homeTeamStartingPitcherID,
        this.currentPitchingTeamID,
        this.currentHittingTeamID,
        this.pointSpread,
        this.overUnder,
        this.awayTeamMoneyLine,
        this.homeTeamMoneyLine,
        this.forecastTempLow,
        this.forecastTempHigh,
        this.forecastDescription,
        this.forecastWindChill,
        this.forecastWindSpeed,
        this.forecastWindDirection,
        this.rescheduledFromGameID,
        this.runnerOnFirst,
        this.runnerOnSecond,
        this.runnerOnThird,
        this.awayTeamStartingPitcher,
        this.homeTeamStartingPitcher,
        this.currentPitcher,
        this.currentHitter,
        this.winningPitcher,
        this.losingPitcher,
        this.savingPitcher,
        this.dueUpHitterID1,
        this.dueUpHitterID2,
        this.dueUpHitterID3,
        this.globalGameID,
        this.globalAwayTeamID,
        this.globalHomeTeamID,
        this.pointSpreadAwayTeamMoneyLine,
        this.pointSpreadHomeTeamMoneyLine,
        this.lastPlay,
        this.isClosed,
        this.updated,
        this.gameEndDateTime,
        this.homeRotationNumber,
        this.awayRotationNumber,
        this.neutralVenue,
        this.innings});

  GameObject.fromJson(Map<String, dynamic> json) {
    gameID = json['GameID'];
    season = json['Season'];
    seasonType = json['SeasonType'];
    status = json['Status'];
    day = json['Day'];
    dateTime = json['DateTime'];
    awayTeam = json['AwayTeam'];
    homeTeam = json['HomeTeam'];
    awayTeamID = json['AwayTeamID'];
    homeTeamID = json['HomeTeamID'];
    rescheduledGameID = json['RescheduledGameID'];
    stadiumID = json['StadiumID'];
    channel = json['Channel'];
    inning = json['Inning'];
    inningHalf = json['InningHalf'];
    awayTeamRuns = json['AwayTeamRuns'];
    homeTeamRuns = json['HomeTeamRuns'];
    awayTeamHits = json['AwayTeamHits'];
    homeTeamHits = json['HomeTeamHits'];
    awayTeamErrors = json['AwayTeamErrors'];
    homeTeamErrors = json['HomeTeamErrors'];
    winningPitcherID = json['WinningPitcherID'];
    losingPitcherID = json['LosingPitcherID'];
    savingPitcherID = json['SavingPitcherID'];
    attendance = json['Attendance'];
    awayTeamProbablePitcherID = json['AwayTeamProbablePitcherID'];
    homeTeamProbablePitcherID = json['HomeTeamProbablePitcherID'];
    outs = json['Outs'];
    balls = json['Balls'];
    strikes = json['Strikes'];
    currentPitcherID = json['CurrentPitcherID'];
    currentHitterID = json['CurrentHitterID'];
    awayTeamStartingPitcherID = json['AwayTeamStartingPitcherID'];
    homeTeamStartingPitcherID = json['HomeTeamStartingPitcherID'];
    currentPitchingTeamID = json['CurrentPitchingTeamID'];
    currentHittingTeamID = json['CurrentHittingTeamID'];
    pointSpread = json['PointSpread'];
    overUnder = json['OverUnder'];
    awayTeamMoneyLine = json['AwayTeamMoneyLine'];
    homeTeamMoneyLine = json['HomeTeamMoneyLine'];
    forecastTempLow = json['ForecastTempLow'];
    forecastTempHigh = json['ForecastTempHigh'];
    forecastDescription = json['ForecastDescription'];
    forecastWindChill = json['ForecastWindChill'];
    forecastWindSpeed = json['ForecastWindSpeed'];
    forecastWindDirection = json['ForecastWindDirection'];
    rescheduledFromGameID = json['RescheduledFromGameID'];
    runnerOnFirst = json['RunnerOnFirst'];
    runnerOnSecond = json['RunnerOnSecond'];
    runnerOnThird = json['RunnerOnThird'];
    awayTeamStartingPitcher = json['AwayTeamStartingPitcher'];
    homeTeamStartingPitcher = json['HomeTeamStartingPitcher'];
    currentPitcher = json['CurrentPitcher'];
    currentHitter = json['CurrentHitter'];
    winningPitcher = json['WinningPitcher'];
    losingPitcher = json['LosingPitcher'];
    savingPitcher = json['SavingPitcher'];
    dueUpHitterID1 = json['DueUpHitterID1'];
    dueUpHitterID2 = json['DueUpHitterID2'];
    dueUpHitterID3 = json['DueUpHitterID3'];
    globalGameID = json['GlobalGameID'];
    globalAwayTeamID = json['GlobalAwayTeamID'];
    globalHomeTeamID = json['GlobalHomeTeamID'];
    pointSpreadAwayTeamMoneyLine = json['PointSpreadAwayTeamMoneyLine'];
    pointSpreadHomeTeamMoneyLine = json['PointSpreadHomeTeamMoneyLine'];
    lastPlay = json['LastPlay'];
    isClosed = json['IsClosed'];
    updated = json['Updated'];
    gameEndDateTime = json['GameEndDateTime'];
    homeRotationNumber = json['HomeRotationNumber'];
    awayRotationNumber = json['AwayRotationNumber'];
    neutralVenue = json['NeutralVenue'];
    if (json['Innings'] != null) {
      innings = new List<Innings>();
      json['Innings'].forEach((v) {
        innings.add(new Innings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GameID'] = this.gameID;
    data['Season'] = this.season;
    data['SeasonType'] = this.seasonType;
    data['Status'] = this.status;
    data['Day'] = this.day;
    data['DateTime'] = this.dateTime;
    data['AwayTeam'] = this.awayTeam;
    data['HomeTeam'] = this.homeTeam;
    data['AwayTeamID'] = this.awayTeamID;
    data['HomeTeamID'] = this.homeTeamID;
    data['RescheduledGameID'] = this.rescheduledGameID;
    data['StadiumID'] = this.stadiumID;
    data['Channel'] = this.channel;
    data['Inning'] = this.inning;
    data['InningHalf'] = this.inningHalf;
    data['AwayTeamRuns'] = this.awayTeamRuns;
    data['HomeTeamRuns'] = this.homeTeamRuns;
    data['AwayTeamHits'] = this.awayTeamHits;
    data['HomeTeamHits'] = this.homeTeamHits;
    data['AwayTeamErrors'] = this.awayTeamErrors;
    data['HomeTeamErrors'] = this.homeTeamErrors;
    data['WinningPitcherID'] = this.winningPitcherID;
    data['LosingPitcherID'] = this.losingPitcherID;
    data['SavingPitcherID'] = this.savingPitcherID;
    data['Attendance'] = this.attendance;
    data['AwayTeamProbablePitcherID'] = this.awayTeamProbablePitcherID;
    data['HomeTeamProbablePitcherID'] = this.homeTeamProbablePitcherID;
    data['Outs'] = this.outs;
    data['Balls'] = this.balls;
    data['Strikes'] = this.strikes;
    data['CurrentPitcherID'] = this.currentPitcherID;
    data['CurrentHitterID'] = this.currentHitterID;
    data['AwayTeamStartingPitcherID'] = this.awayTeamStartingPitcherID;
    data['HomeTeamStartingPitcherID'] = this.homeTeamStartingPitcherID;
    data['CurrentPitchingTeamID'] = this.currentPitchingTeamID;
    data['CurrentHittingTeamID'] = this.currentHittingTeamID;
    data['PointSpread'] = this.pointSpread;
    data['OverUnder'] = this.overUnder;
    data['AwayTeamMoneyLine'] = this.awayTeamMoneyLine;
    data['HomeTeamMoneyLine'] = this.homeTeamMoneyLine;
    data['ForecastTempLow'] = this.forecastTempLow;
    data['ForecastTempHigh'] = this.forecastTempHigh;
    data['ForecastDescription'] = this.forecastDescription;
    data['ForecastWindChill'] = this.forecastWindChill;
    data['ForecastWindSpeed'] = this.forecastWindSpeed;
    data['ForecastWindDirection'] = this.forecastWindDirection;
    data['RescheduledFromGameID'] = this.rescheduledFromGameID;
    data['RunnerOnFirst'] = this.runnerOnFirst;
    data['RunnerOnSecond'] = this.runnerOnSecond;
    data['RunnerOnThird'] = this.runnerOnThird;
    data['AwayTeamStartingPitcher'] = this.awayTeamStartingPitcher;
    data['HomeTeamStartingPitcher'] = this.homeTeamStartingPitcher;
    data['CurrentPitcher'] = this.currentPitcher;
    data['CurrentHitter'] = this.currentHitter;
    data['WinningPitcher'] = this.winningPitcher;
    data['LosingPitcher'] = this.losingPitcher;
    data['SavingPitcher'] = this.savingPitcher;
    data['DueUpHitterID1'] = this.dueUpHitterID1;
    data['DueUpHitterID2'] = this.dueUpHitterID2;
    data['DueUpHitterID3'] = this.dueUpHitterID3;
    data['GlobalGameID'] = this.globalGameID;
    data['GlobalAwayTeamID'] = this.globalAwayTeamID;
    data['GlobalHomeTeamID'] = this.globalHomeTeamID;
    data['PointSpreadAwayTeamMoneyLine'] = this.pointSpreadAwayTeamMoneyLine;
    data['PointSpreadHomeTeamMoneyLine'] = this.pointSpreadHomeTeamMoneyLine;
    data['LastPlay'] = this.lastPlay;
    data['IsClosed'] = this.isClosed;
    data['Updated'] = this.updated;
    data['GameEndDateTime'] = this.gameEndDateTime;
    data['HomeRotationNumber'] = this.homeRotationNumber;
    data['AwayRotationNumber'] = this.awayRotationNumber;
    data['NeutralVenue'] = this.neutralVenue;
    if (this.innings != null) {
      data['Innings'] = this.innings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
