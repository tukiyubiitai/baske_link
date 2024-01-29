// ページの状態を表すenum
enum AuthStatus {
  unauthenticated, // 認証されていない
  accountNotCreated, // アカウントはあるが、Firestoreにデータがない
  authenticated // 認証され、Firestoreにデータがある
}
