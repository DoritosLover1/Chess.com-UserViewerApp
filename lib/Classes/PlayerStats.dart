// PlayerStats.dart
class PlayerStats {
  final ChessMode? chessDaily;
  final ChessMode? chess960Daily;
  final ChessMode? chessRapid;
  final ChessMode? chessBullet;
  final ChessMode? chessBlitz;
  final int? fideRating;
  final Tactics? tactics;
  final PuzzleRush? puzzleRush;

  PlayerStats({
    this.chessDaily,
    this.chess960Daily,
    this.chessRapid,
    this.chessBullet,
    this.chessBlitz,
    this.fideRating,
    this.tactics,
    this.puzzleRush,
  });

  static bool _isValid(dynamic data) {
    return data != null && data is Map && data.isNotEmpty;
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      chessDaily: _isValid(json['chess_daily'])
          ? ChessMode.fromJson(json['chess_daily']) 
          : null,
      chess960Daily: _isValid(json['chess960_daily'])
          ? ChessMode.fromJson(json['chess960_daily']) 
          : null,
      chessRapid: _isValid(json['chess_rapid'])
          ? ChessMode.fromJson(json['chess_rapid']) 
          : null,
      chessBullet: _isValid(json['chess_bullet'])
          ? ChessMode.fromJson(json['chess_bullet']) 
          : null,
      chessBlitz: _isValid(json['chess_blitz'])
          ? ChessMode.fromJson(json['chess_blitz']) 
          : null,
      fideRating: json['fide'],
      tactics: _isValid(json['tactics'])
          ? Tactics.fromJson(json['tactics']) 
          : null,
      puzzleRush: _isValid(json['puzzle_rush'])
          ? PuzzleRush.fromJson(json['puzzle_rush']) 
          : null,
    );
  }
}

class ChessMode {
  final RatingInfo? last;
  final BestGame? best;
  final Record? record;

  ChessMode({this.last, this.best, this.record});

  static bool _isValid(dynamic data) {
    return data != null && data is Map && data.isNotEmpty;
  }

  factory ChessMode.fromJson(Map<String, dynamic> json) {
    return ChessMode(
      last: _isValid(json['last']) ? RatingInfo.fromJson(json['last']) : null,
      best: _isValid(json['best']) ? BestGame.fromJson(json['best']) : null,
      record: _isValid(json['record']) ? Record.fromJson(json['record']) : null,
    );
  }
}

class RatingInfo {
  final int rating;
  final int date;
  final int rd;

  RatingInfo({
    required this.rating,
    required this.date,
    required this.rd,
  });

  factory RatingInfo.fromJson(Map<String, dynamic> json) {
    return RatingInfo(
      rating: json['rating'] ?? 0,
      date: json['date'] ?? 0,
      rd: json['rd'] ?? 0,
    );
  }
}

class BestGame {
  final int rating;
  final int date;
  final String game;

  BestGame({
    required this.rating,
    required this.date,
    required this.game,
  });

  factory BestGame.fromJson(Map<String, dynamic> json) {
    return BestGame(
      rating: json['rating'] ?? 0,
      date: json['date'] ?? 0,
      game: json['game'] ?? '',
    );
  }
}

class Record {
  final int win;
  final int loss;
  final int draw;
  final int? timePerMove;
  final int? timeoutPercent;

  Record({
    required this.win,
    required this.loss,
    required this.draw,
    this.timePerMove,
    this.timeoutPercent,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      win: json['win'] ?? 0,
      loss: json['loss'] ?? 0,
      draw: json['draw'] ?? 0,
      timePerMove: json['time_per_move'],
      timeoutPercent: json['timeout_percent'],
    );
  }
}

class Tactics {
  final TacticsRating? highest;
  final TacticsRating? lowest;

  Tactics({this.highest, this.lowest});

  static bool _isValid(dynamic data) {
    return data != null && data is Map && data.isNotEmpty;
  }

  factory Tactics.fromJson(Map<String, dynamic> json) {
    return Tactics(
      highest: _isValid(json['highest']) 
          ? TacticsRating.fromJson(json['highest'])
          : null,
      lowest: _isValid(json['lowest']) 
          ? TacticsRating.fromJson(json['lowest'])
          : null,
    );
  }
}

class TacticsRating {
  final int rating;
  final int date;

  TacticsRating({required this.rating, required this.date});

  factory TacticsRating.fromJson(Map<String, dynamic> json) {
    return TacticsRating(
      rating: json['rating'] ?? 0,
      date: json['date'] ?? 0,
    );
  }
}

class PuzzleRush {
  final PuzzleRushBest? best;

  PuzzleRush({this.best});

  static bool _isValid(dynamic data) {
    return data != null && data is Map && data.isNotEmpty;
  }

  factory PuzzleRush.fromJson(Map<String, dynamic> json) {
    return PuzzleRush(
      best: _isValid(json['best']) 
          ? PuzzleRushBest.fromJson(json['best'])
          : null,
    );
  }
}

class PuzzleRushBest {
  final int totalAttempts;
  final int score;

  PuzzleRushBest({required this.totalAttempts, required this.score});

  factory PuzzleRushBest.fromJson(Map<String, dynamic> json) {
    return PuzzleRushBest(
      totalAttempts: json['total_attempts'] ?? 0,
      score: json['score'] ?? 0,
    );
  }
}