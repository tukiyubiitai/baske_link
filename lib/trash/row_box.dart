import 'package:flutter/material.dart';

Widget ColorBox(
    {required String text, required String img, required String title}) {
  return SizedBox(
    width: 180,
    height: 150,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.indigo[900],
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 50,
                height: 50,
                child: Image.asset(img),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.black),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Text(
//                                               "チーム目標",
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             Container(
//                                                 width: 40,
//                                                 height: 40,
//                                                 child: Image.asset(
//                                                     "assets/images/award.png"))
//                                           ],
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             teamProvider.goal.toString(),
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: Colors.white),
//                                             maxLines: 3,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
