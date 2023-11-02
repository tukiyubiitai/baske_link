const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.myFunction = functions.firestore
  .document("room/{roomId}/message/{messageId}")
  .onCreate(async (snapshot, context) => {
    const userId = snapshot.data()["recipient_id"];//相手のId
    const myUserID = snapshot.data()["sender_id"];//自分のId

    console.log("userId:", userId);
    console.log("myUserID:", myUserID);

    //これがないと自分にも通知が来る
    if (userId !== myUserID) {
    //相手のトークを取得します
      const targetUserTokens = await getTargetUserTokens(userId);

      if (targetUserTokens && targetUserTokens.length > 0) {
        const message = {
          notification: {
            title: snapshot.data()["user_name"],
            body: snapshot.data()["message"],
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
            sound: "default",
          },
        };

        // 特定のユーザーに向けてメッセージを送信
        return admin.messaging().sendToDevice(targetUserTokens, message)
          .then((response) => {
            // Handle the response if needed.
            return response;
          })
          .catch((error) => {
            console.error("Error sending notification:", error);
          });
      } else {
        console.log("Target user has no registered devices.");
        return null;
      }
    }

    return null;
  });

//相手のトークンを取得
async function getTargetUserTokens(userId) {
  try {
    const userDoc = await admin.firestore().collection("users").doc(userId).get();

    if (userDoc.exists) {
      const userData = userDoc.data();
      console.log("userData:", userData); // ユーザーデータをログに出力
      const registrationTokens = userData.myToken;
      console.log("registrationTokens:", registrationTokens); // myTokenをログに出力


      if (registrationTokens && registrationTokens.length > 0) {
        return registrationTokens;
      } else {
        console.log("Target user has no registered devices.");
        return null;
      }
    } else {
      console.log("Target user document not found.");
      return null;
    }
  } catch (error) {
    console.error("Error getting target user registration tokens:", error);
    return null;
  }
}
