enum PostReportReason {
  irrelevantPost,
  abuseThreat,
  harassment,
  spam,
  sexualContent,
  other
}

// 例: ReportReasonをStringに変換
String postReportReasonToString(PostReportReason reason) {
  switch (reason) {
    case PostReportReason.irrelevantPost:
      return "関係の無い投稿";
    case PostReportReason.abuseThreat:
      return "暴言や脅迫";
    case PostReportReason.harassment:
      return "嫌がらせ";
    case PostReportReason.spam:
      return "スパム";
    case PostReportReason.sexualContent:
      return "性的な表現";
    case PostReportReason.other:
    default:
      return "その他";
  }
}

enum UserReportReason {
  irrelevantPost,
  abuseThreat,
  harassment,
  spam,
  sexualContent,
  other
}

// 例: ReportReasonをStringに変換
String userReportReasonToString(UserReportReason reason) {
  switch (reason) {
    case UserReportReason.irrelevantPost:
      return "誹謗中傷";
    case UserReportReason.abuseThreat:
      return "暴言や脅迫";
    case UserReportReason.harassment:
      return "嫌がらせ";
    case UserReportReason.spam:
      return "スパム";
    case UserReportReason.sexualContent:
      return "性的な嫌がらせ / 出会い目的";
    case UserReportReason.other:
    default:
      return "その他";
  }
}
