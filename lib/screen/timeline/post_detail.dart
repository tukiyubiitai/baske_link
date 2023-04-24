import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatelessWidget {
  final String createAt;
  final String teamName;
  final String formattedDate;
  final String formattedStartTime;
  final String formattedEndTime;
  final String location;

  final String recruitNumber;
  final List<String> targetList;
  final String contact;
  String? imageUrl;
  String? note;

  PostDetail({
    required this.createAt,
    required this.teamName,
    required this.formattedDate,
    required this.formattedStartTime,
    required this.formattedEndTime,
    required this.location,
    required this.recruitNumber,
    required this.targetList,
    required this.contact,
    this.imageUrl,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("詳細ページ"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("投稿日：" +
                    DateFormat('yyyy/MM/dd').format(DateTime.parse(createAt))),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    teamName,
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                        location,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      ' ${recruitNumber}' + '人',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      ' $contact',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 10),
                note != null
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
                                title: Text(
                                  note!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
      ),
    );
  }
}
