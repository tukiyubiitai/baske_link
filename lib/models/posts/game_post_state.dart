class GameState {
  final String id;
  final String postAccountId;
  final String locationTagString; //エリア
  final String prefecture; // 場所
  final int level; // レベル
  final String teamName; // チーム名
  final String createdTime; //投稿時間
  final String member; //構成メンバー
  final String ageString; //年齢層

  final String type; //投稿種類

  String? imageUrl; //画像

  String? oldImageUrl;

  String? note; //自由欄

  GameState(
      {this.id = "",
      this.postAccountId = "",
      this.locationTagString = "",
      this.teamName = "",
      this.level = 0,
      this.prefecture = "",
      this.createdTime = "",
      this.member = "",
      this.ageString = "",
      this.type = "",
      this.imageUrl = "",
      this.oldImageUrl = "",
      this.note = ""});

  GameState copyWith({
    String? id,
    String? postAccountId,
    String? locationTagString, //エリア
    String? prefecture, // 場所
    int? level, // レベル
    String? teamName, // チーム名
    String? createdTime, //投稿時間
    String? member, //構成メンバー
    String? ageString, //年齢層

    String? type, //投稿種類

    String? imageUrl, //画像
    String? oldImageUrl,
    String? note, //自由欄
  }) {
    return GameState(
      id: id ?? this.id,
      postAccountId: postAccountId ?? this.postAccountId,
      locationTagString: locationTagString ?? this.locationTagString,
      prefecture: prefecture ?? this.prefecture,
      level: level ?? this.level,
      teamName: teamName ?? this.teamName,
      createdTime: createdTime ?? this.createdTime,
      member: member ?? this.member,
      ageString: ageString ?? this.ageString,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      oldImageUrl: oldImageUrl ?? this.oldImageUrl,
      note: note ?? this.note,
    );
  }
}
