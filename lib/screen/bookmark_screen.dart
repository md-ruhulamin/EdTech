import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edtech/controller/controller.dart';
import 'package:edtech/model/bookmark.dart';
import 'package:edtech/utils/color.dart';
import 'package:edtech/widget/big_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksScreen extends StatefulWidget {
  final int videoId;
  BookmarksScreen({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

BookMarkController _controller = BookMarkController();

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Bookmark>>(
                future: fetchMyData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Future is still loading
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Future encountered an error
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Future completed, but there is no data
                    return const Text('No bookmarks available.');
                  } else {
                    List<Bookmark> bookmarkList = [];
                    for (int i = 0; i < snapshot.data!.length; i++) {
                      if (snapshot.data![i].videoId == widget.videoId) {
                        bookmarkList.add(snapshot.data![i]);
                      }
                      print(snapshot.data![i].videoId);
                      print(snapshot.data![i].title);
                      print(widget.videoId);
                    }

                    // Future completed successfully, display the list of bookmarks

                    return ListView.builder(
                        itemCount: bookmarkList.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            leading: Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.buttonBackgroundColor2,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  bookmarkList[index].videoId.toString(),
                                  textAlign: TextAlign.center,
                                )),
                            title: BigText(
                              text: ' ${bookmarkList[index].title}',
                              size: 12,
                            ),
                            subtitle: BigText(
                              text: 'Time: ${bookmarkList[index].duration}',
                              size: 12,
                              color: Colors.grey,
                            ),
                            // Add more options like delete, go to bookmark, etc.
                          );
                        }));
                  }
                },
              ),
            ),
            // Expanded(
            //   child: FutureBuilder<List<Bookmark>>(
            //     future: fetchMyData(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return CircularProgressIndicator();
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //         // CustomSnackBar(context, Text("Error: ${snapshot.error}"));
            //       } else {
            //         final bookmarkList = snapshot.data;
            //         return ListView.builder(
            //             itemCount: bookmarkList!.length,
            //             itemBuilder: ((context, index) {
            //               return ListTile(
            //                 leading: Container(
            //                     height: 50,
            //                     alignment: Alignment.center,
            //                     width: 50,
            //                     decoration: BoxDecoration(
            //                         color: AppColors.buttonBackgroundColor2,
            //                         borderRadius: BorderRadius.circular(100)),
            //                     child: Text(
            //                       index.toString(),
            //                       textAlign: TextAlign.center,
            //                     )),
            //                 title: BigText(
            //                   text: ' ${bookmarkList[index].title}',
            //                   size: 12,
            //                 ),
            //                 subtitle: BigText(
            //                   text: 'Time: ${bookmarkList[index].duration}',
            //                   size: 12,
            //                   color: Colors.grey,
            //                 ),
            //                 // Add more options like delete, go to bookmark, etc.
            //               );
            //             }));
            //       }
            //     },
            //   ),
            // )
          ],
        )),
      ),
    );
  }

  Future<List<Bookmark>> fetchMyData() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('bookmark').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Bookmark.fromMap(data);
    }).toList();
  }

  Future<List<Bookmark>> getBookmarkList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('bookmarkList') ?? [];
    return encodedList
        .map((encodedBookmark) => Bookmark.fromString(encodedBookmark))
        .toList();
  }
}
