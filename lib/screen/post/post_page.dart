import 'dart:io';

import 'package:basketball_app/screen/post/select_location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;

  File? _storeImage; //画像
  String? imageUrl; //画像URL
  final picker = ImagePicker();

  late DatabaseReference dbRef;

  // 必須項目のフォームのコントローラー
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<String> _filters = [];

  //非必須項目のフォームのコントローラー
  final TextEditingController _noteController = TextEditingController();

  //時間
  DateTime _selectedDate = DateTime.now();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  String _startTime = '';
  String _endTime = '';
  String? _errorText;

  //DateTime型からUnix時間に変換ため
  late int unixTimestamp;
  late int startUnixTimestamp;
  late int endUnixTimestamp;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Recruitment');
  }

  Future<String?> _uploadImage(File _storeImage) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        referenceRoot.child('images/${uniqueFileName}');
    try {
      // Store the file
      await referenceDirImages.putFile(File(_storeImage.path));
      // Success: get the download URL
      String downloadUrl = await referenceDirImages.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  //日付、時間のエラー処理と
  void _checkTimeValidity() {
    //_startTimeをDateTimeに変換
    _start = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(_startTime.split(':')[0]),
        int.parse(_startTime.split(':')[1]));
    startUnixTimestamp = _start.millisecondsSinceEpoch;
    //_endTime_をDateTimeに変換
    _end = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
        int.parse(_endTime.split(':')[0]), int.parse(_endTime.split(':')[1]));
    endUnixTimestamp = _end.millisecondsSinceEpoch;
    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(endUnixTimestamp);
    // print(dateTime);

    if (_start == _end) {
      // 開始時間と終了時間が同じ場合
      setState(() {
        _errorText = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '開始時間と終了時間が同じです。',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else if (_start.isAfter(_end)) {
      // 開始時間が終了時間より後の場合
      setState(() {
        _errorText = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '終了時間は開始時間より後に設定してください。',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // エラーがない場合はエラーメッセージをクリアする
      setState(() {
        _errorText = null;
      });
    }
  }

  //日付
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateTimeController.text =
            '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日';
        unixTimestamp = _selectedDate.millisecondsSinceEpoch;
      });
    }
  }

  //開始時間
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        _startTimeController.text = _startTime;
        _checkTimeValidity();
      });
    }
  }

  //終了時間
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        _endTimeController.text = _endTime;
        _checkTimeValidity();
      });
    }
  }

  //データベースに登録する
  Future<void> _submitRecruitment() async {
    // 画像をアップロードしてURLを取得
    final String? url =
        _storeImage != null ? await _uploadImage(_storeImage!) : null;
    try {
      Map<String, dynamic> recruitment = {
        "teamName": _titleController.text,
        "dateTime": unixTimestamp,
        "startTime": startUnixTimestamp,
        "endTime": endUnixTimestamp,
        "location": _addressController.text,
        "recruitNumber": _feeController.text,
        "contact": _contactController.text,
        "imageUrl": url,
        "target": _filters,
        "created_at": DateTime.now().toIso8601String(),
      };
      if (_noteController.text.isNotEmpty) {
        recruitment["note"] = _noteController.text;
      }
      dbRef.push().set(recruitment);
      final snackBar = SnackBar(
        content: Text('投稿が完了しました'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      final snackBar = SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    return null;
  }

  Iterable<Widget> get filterChip sync* {
    for (FilterChipItemWidget filterChipItem in _filterChipItems) {
      yield FilterChip(
        backgroundColor: Colors.black26,
        label: Text(
          filterChipItem.name,
        ),
        selected: _filters.contains(filterChipItem.name),
        selectedColor: Colors.lightBlueAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _filters.add(filterChipItem.name);
            } else {
              _filters.removeWhere((String name) {
                return name == filterChipItem.name;
              });
            }
          });
          print(_filters);
        },
      );
    }
  }

  List<FilterChipItemWidget> _filterChipItems = <FilterChipItemWidget>[
    FilterChipItemWidget('未経験OK'),
    FilterChipItemWidget('経験者のみ'),
    FilterChipItemWidget('ブランクOK'),
    FilterChipItemWidget('男性のみ'),
    FilterChipItemWidget('女性のみ'),
    FilterChipItemWidget('男女'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_filters.length == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '対象者を選択してください',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (_formKey.currentState!.validate()) {
                _checkTimeValidity();
                _submitRecruitment();
              }
            },
            child: Text(
              '投稿する',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'チーム名',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  maxLength: 25,
                  decoration: InputDecoration(
                    labelText: "チーム名",
                    prefixIcon: Icon(Icons.diversity_3),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    text: '日時',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                    readOnly: true,
                    controller: _dateTimeController,
                    decoration: InputDecoration(
                      labelText: "日時",
                      prefixIcon: Icon(Icons.event),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateRequiredField,
                    onTap: () {
                      _selectDate(context);
                    }),
                SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    text: '開始時間と終了時間',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          readOnly: true,
                          controller: _startTimeController,
                          decoration: InputDecoration(
                            labelText: "開始時間",
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(),
                            errorMaxLines: 2,
                            errorText: _errorText,
                          ),
                          validator: _validateRequiredField,
                          onTap: () {
                            _selectStartTime(context);
                          }),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                          readOnly: true,
                          controller: _endTimeController,
                          decoration: InputDecoration(
                            labelText: "終了時間",
                            prefixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(),
                            errorText: _errorText,
                            errorMaxLines: 2,
                          ),
                          validator: _validateRequiredField,
                          onTap: () {
                            _selectEndTime(context);
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    text: '場所',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _addressController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "場所",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    var selectedPlace = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectLocation()));
                    if (selectedPlace != null) {
                      selectedPlace = selectedPlace.replaceAll("日本、", "");
                      _addressController.text = selectedPlace;
                    }
                  },
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    text: '募集人数',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _feeController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: "フリーの場合は99にしてください",
                    prefixIcon: Icon(Icons.accessibility),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequiredField,
                ),
                Text.rich(
                  TextSpan(
                    text: '対象者',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '(複数可)',
                        style: TextStyle(fontSize: 16.0, color: Colors.black87),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 0.0,
                  children: filterChip.toList(),
                ),

                SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    text: '連絡先',
                    style: TextStyle(fontSize: 20.0),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: "連絡先",
                    prefixIcon: Icon(Icons.contact_mail_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequiredField,
                ),
                SizedBox(height: 16.0),
                //画像
                _imageInput(),
                SizedBox(height: 16.0),
                Text(
                  'アピールポイント・連絡事項',
                  style: TextStyle(fontSize: 20.0),
                ),
                TextFormField(
                  controller: _noteController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "活動内容など",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _checkTimeValidity();
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: Text(
                      '投稿する',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //カメラから画像を取得
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    //写真のファイルパスを取得
    final imageFile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    _clearImage();
    setState(() {
      _storeImage = File(imageFile!.path);
    });
  }

  //ファイルから画像を取得
  Future _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _clearImage();
    setState(() {
      _storeImage = File(pickedFile!.path);
    });
  }

  // 画像のクリア
  void _clearImage() {
    setState(() {
      _storeImage = null;
    });
  }

  //画像追加
  Widget _imageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "画像を追加する",
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              child: _storeImage != null
                  ? Image.file(
                      _storeImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      "No Image",
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: Icon(Icons.camera_alt),
                    label: Text("カメラ"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _getImageFromGallery,
                    icon: Icon(Icons.folder_copy),
                    label: Text("フォルダ"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FilterChipItemWidget {
  const FilterChipItemWidget(this.name);

  final String name;
}
