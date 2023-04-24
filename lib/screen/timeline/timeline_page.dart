import 'package:basketball_app/screen/post/post_page.dart';
import 'package:basketball_app/screen/timeline/post_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelinePage extends StatefulWidget {
  final User user;

  TimelinePage({required this.user});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Recruitment');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Recruitment');

  Widget listItem({required Map recruitment}) {
    int unixDateTime = recruitment['dateTime'];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixDateTime);
    String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);

    int unixStartTime = recruitment['startTime'];
    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(unixStartTime);
    String formattedStartTime = DateFormat('HH:mm').format(startTime);

    int unixEndTime = recruitment['endTime'];
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(unixEndTime);
    String formattedEndTime = DateFormat('HH:mm').format(endTime);

    List<String> targetList =
        List<String>.from(recruitment['target'].map((e) => e.toString()));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostDetail(
                    createAt: recruitment['created_at'],
                    teamName: recruitment['teamName'],
                    formattedDate: formattedDate,
                    formattedStartTime: formattedStartTime,
                    formattedEndTime: formattedEndTime,
                    location: recruitment['location'],
                    recruitNumber: recruitment['recruitNumber'],
                    targetList: targetList,
                    contact: recruitment['contact'],
                    imageUrl: recruitment['imageUrl'],
                    note: recruitment['note'],
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("投稿日：" +
                  DateFormat('yyyy/MM/dd')
                      .format(DateTime.parse(recruitment['created_at']))),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  recruitment['teamName'],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Icons.date_range,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$formattedStartTime ~ $formattedEndTime',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      recruitment['location'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '募集人数:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    ' ${recruitment['recruitNumber']} 人',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '対象者:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${targetList.take(3).join(', ')}' + // 0, 1, 2
                        '${targetList.length > 3 ? '\n' : ''}' + // リストが3つ以上の場合は改行する
                        '${targetList.skip(3).join(', ')}', // 3以降の要素を改行して表示する
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.contact_phone,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '連絡先:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    ' ${recruitment['contact']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 10),
              recruitment['imageUrl'] != null
                  ? Image.network(
                      recruitment['imageUrl'],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              recruitment['note'] != null
                  ? Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '活動内容:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              title: Text(
                                recruitment['note'].length > 150
                                    ? '${recruitment['note'].substring(0, 150)} ...'
                                    : recruitment['note'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: recruitment['note'].length > 100
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PostDetail(
                                                    createAt: recruitment[
                                                        'created_at'],
                                                    teamName:
                                                        recruitment['teamName'],
                                                    formattedDate:
                                                        formattedDate,
                                                    formattedStartTime:
                                                        formattedStartTime,
                                                    formattedEndTime:
                                                        formattedEndTime,
                                                    location:
                                                        recruitment['location'],
                                                    recruitNumber: recruitment[
                                                        'recruitNumber'],
                                                    targetList: targetList,
                                                    contact:
                                                        recruitment['contact'],
                                                    imageUrl:
                                                        recruitment['imageUrl'],
                                                    note: recruitment['note'],
                                                  )),
                                        );
                                      },
                                      child: Text('続きを見る'),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("募集ページ"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          reverse: true,
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map recruitment = snapshot.value as Map;
            recruitment["key"] = snapshot.key;
            return listItem(recruitment: recruitment);
          },
        ),
      ),
    );
  }
}
