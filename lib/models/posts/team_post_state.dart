class TeamPostState {
  final String id; //ユーザID

  final String postAccountId; //投稿したユーザID
  final String teamName;
  final String activityTime;
  final String prefecture; // エリア
  final String locationTagString; //　場所
  final String targetString; //ターゲット層
  final String ageString; //年齢層

  final String? teamAppeal; //チームアピール
  final String? cost; //会費
  final String? goal; // 目標
  final String? memberCount; // メンバー数
  final String? imageUrl; //画像
  final String? oldImageUrl;
  final String? oldHeaderUrl;

  final String? headerUrl; //ヘッダー画像
  final String? note; //詳細
  final String type; //投稿の種類

  TeamPostState({
    this.id = "",
    this.postAccountId = "",
    this.teamName = "",
    this.activityTime = "",
    this.prefecture = "",
    this.locationTagString = "",
    this.targetString = "",
    this.ageString = "",
    this.teamAppeal = "",
    this.cost = "",
    this.goal = "",
    this.memberCount = "",
    this.imageUrl = "",
    this.headerUrl = "",
    this.note = "",
    this.type = "",
    this.oldImageUrl = "",
    this.oldHeaderUrl = "",
  });

  TeamPostState copyWith({
    String? id,
    String? postAccountId,
    String? teamName,
    String? activityTime,
    String? prefecture,
    String? locationTagString,
    String? targetString,
    String? ageString,
    String? teamAppeal,
    String? cost,
    String? goal,
    String? memberCount,
    String? imageUrl,
    String? headerUrl,
    String? note,
    String? type,
    String? oldImageUrl,
    String? oldHeaderUrl,
  }) {
    return TeamPostState(
      id: id ?? this.id,
      postAccountId: postAccountId ?? this.postAccountId,
      teamName: teamName ?? this.teamName,
      activityTime: activityTime ?? this.activityTime,
      prefecture: prefecture ?? this.prefecture,
      locationTagString: locationTagString ?? this.locationTagString,
      targetString: targetString ?? this.targetString,
      ageString: ageString ?? this.ageString,
      teamAppeal: teamAppeal ?? this.teamAppeal,
      cost: cost ?? this.cost,
      goal: goal ?? this.goal,
      memberCount: memberCount ?? this.memberCount,
      imageUrl: imageUrl ?? this.imageUrl,
      headerUrl: headerUrl ?? this.headerUrl,
      note: note ?? this.note,
      type: type ?? this.type,
      oldImageUrl: oldImageUrl ?? this.oldImageUrl,
      oldHeaderUrl: oldHeaderUrl ?? this.oldHeaderUrl,
    );
  }
}
