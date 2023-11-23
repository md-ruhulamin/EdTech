import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edtech/model/bookmark.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkController extends GetxController {
  RxList<Bookmark> _bookmark = <Bookmark>[].obs;
  RxInt selectedItem = 1.obs;
  void saveBookMark(int videoId, String duration, String title) {
    _bookmark.add(Bookmark(videoId: videoId, title: title, duration: duration));
    //  showBookmark();
    saveBookmarkList(_bookmark);
  }

  RxList<Bookmark> get bookmark => _bookmark;



  Future<void> saveBookmarkList(List<Bookmark> bookmarkList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList =
        bookmarkList.map((bookmark) => bookmark.toString()).toList();
    prefs.setStringList('bookmarkList', encodedList);
    update();
  }

  Future<List<Bookmark>> getBookmarkList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('bookmarkList') ?? [];
    return encodedList
        .map((encodedBookmark) => Bookmark.fromString(encodedBookmark))
        .toList();
  }

  Future<void> addDataToFiretore(
      int videoId, Duration duration, String title) async {
    try {
      // Get a reference to the Firestore collection

      CollectionReference products =
          FirebaseFirestore.instance.collection('bookmark');
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      // Add a document with data to the collection
      await products.doc(id).set({
        "duration": duration,
        "title": title,
        "videoId": videoId,
      });

      Get.snackbar("FireStore", "$videoId is Added ",
          backgroundColor: Colors.amber, snackPosition: SnackPosition.TOP);

      print('Data added to Firestore');
    } catch (e) {
      // Handle the error here
      print('Error adding data to Firestore: $e');
    }
  }




    Future<void> addDataToFirestore(
      int videoId, String duration, String title) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference bookmarkcollection = firestore.collection('bookmark');
    await bookmarkcollection.add({
      "duration": duration.toString(),
      "title": title,
      "videoId": videoId,
    });

    print('Data added to Firestore!');
  }






  
}
