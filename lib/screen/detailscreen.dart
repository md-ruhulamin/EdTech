// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, non_constant_identifier_names, must_be_immutable

import 'package:chewie/chewie.dart';

import 'package:edtech/controller/controller.dart';
import 'package:edtech/model/bookmark.dart';
import 'package:edtech/screen/bookmark_screen.dart';
import 'package:edtech/screen/signin_Test.dart';
import 'package:edtech/widget/big_text.dart';
import 'package:edtech/widget/primary_btn.dart';
import 'package:edtech/responsive/responsive.dart';
import 'package:edtech/data/courseList.dart';
import 'package:edtech/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:video_player/video_player.dart';

enum DataSourceType { network, asset, contentUri }

class CourseDetailScreen extends StatefulWidget {
  final int courseid;
  const CourseDetailScreen({super.key, required this.courseid});

  @override
  State<CourseDetailScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // print("Width ${MediaQuery.of(context).size.width}");

    // print("Height ${MediaQuery.of(context).size.height}");

    return Responsive(
      desktop: DetailScreenForDeskTop(courseId: widget.courseid),
      tablet: DetailScreenForTablet(courseId: widget.courseid),
      mobile: DetailScreenForMobile(courseId: widget.courseid),
    );
  }
}

class DetailScreenForDeskTop extends StatefulWidget {
  int courseId;

  DetailScreenForDeskTop({super.key, required this.courseId});

  @override
  State<DetailScreenForDeskTop> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreenForDeskTop> {
  BookMarkController bookMarkController = BookMarkController();
  List<Bookmark> bookmarks = [];
  final TextEditingController _bookmarkController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController;

  //    Uri.parse('https://youtu.be/fDzF_w6iJrQ?si=jVfQl5atylLfzqxJ')

  String videoUrl1 =

      //'https://www.youtube.com/watch?v=dIwPi6sX2uQ';
//      'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  int videoID = 0;
  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl1));
    _videoPlayerController.play();
    _chewieController = ChewieController(
        looping: true,
        autoPlay: true,
        startAt: const Duration(seconds: 0),
        videoPlayerController: _videoPlayerController,
        aspectRatio: 1);

    super.initState();
  }

  void loadProperties(String videoUrl, int index) {
    _chewieController = ChewieController(
        autoPlay: true,
        startAt: const Duration(seconds: 0),
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(videoUrl)),
        aspectRatio: 1);

    _bookMarkController.selectedItem.value = index + 1;
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    _bookmarkController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  BookMarkController _bookMarkController = BookMarkController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Your Favorite Course is Here "), actions: [
        IconButton(
            onPressed: () {
              _auth.signOut();
              Get.off(SignInScreen());
            },
            icon: Icon(
              Icons.logout,
            )),
      ]),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                width: 250,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("List of Content"),
                      Expanded(
                          child: MediaQuery.removePadding(
                        context: context,
                        removeRight: true,
                        child: ListView.builder(
                            itemCount: chapterList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  color: selectedIndex == index
                                      ? AppColors.paraColor
                                      : Colors.greenAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _bookMarkController
                                              .selectedItem.value = videoID;
                                          selectedIndex = index;
                                          videoID = selectedIndex + 1;
                                          loadProperties(videoUrl1, videoID);
                                        });
                                      },
                                      child: Text(chapterList[index].title)));
                            }),
                      )),
                    ]),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Chewie(controller: _chewieController),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (0 < selectedIndex) {
                                  selectedIndex--;
                                  videoID = selectedIndex + 1;
                                  loadProperties(videoUrl1, videoID);
                                }
                              });
                            },
                            child: const RoundButton(title: "Previous")),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (chapterList.length > selectedIndex + 1) {
                                  selectedIndex++;
                                  videoID = selectedIndex + 1;
                                  loadProperties(videoUrl1, videoID);
                                }
                              });
                            },
                            child: const RoundButton(title: "Next")),
                        Expanded(child: SizedBox()),
                        SizedBox(
                          width: 200,
                          child: GestureDetector(
                            onTap: () {
                              showClaimCertificateMessage(context);
                            },
                            child: RoundButton(
                              title: "Get Certificate",
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _chewieController.pause();

                                openBottomSheet(context);
                              },
                              child: RoundButton(
                                title: "Bookmark",
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _chewieController.pause();
                                Get.to(BookmarksScreen(
                                  videoId: videoID,
                                ));
                              },
                              child: RoundButton(
                                title: "See all",
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Add your bottom sheet content here
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Book Mark Info'),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bookmarkController,
                decoration: InputDecoration(hintText: "Book Mark Info"),
              ),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    // Close the bottom sheet if needed
                    Navigator.of(context).pop();

                    _bookmarkController.clear();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Close the bottom sheet if needed
                    bookMarkController.saveBookMark(
                      videoID,
                      _videoPlayerController.value.position.toString(),
                      _bookmarkController.text.toString(),
                    );

                    _bookMarkController.addDataToFirestore(
                        videoID,
                        _videoPlayerController.value.position.toString(),
                        _bookmarkController.text.toString());
                    Navigator.of(context).pop();
                    _bookmarkController.clear();
                  },
                  child: Text('Save'),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  void showClaimCertificateMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Congratulations! Claim Your Certificate'),
        action: SnackBarAction(
          label: 'Claim',
          onPressed: () {
            // Redirect to the dashboard or take appropriate action
            Navigator.of(context).pop(); // Close the Snackbar
            // Redirect logic here
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailScreenForTablet extends StatefulWidget {
  int courseId;

  DetailScreenForTablet({super.key, required this.courseId});

  @override
  State<DetailScreenForTablet> createState() => _DetailScreenForTabletState();
}

class _DetailScreenForTabletState extends State<DetailScreenForTablet> {
  BookMarkController bookMarkController = BookMarkController();
  List<Bookmark> bookmarks = [];
  TextEditingController _bookmarkController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ChewieController _chewieController;

  //    Uri.parse('https://youtu.be/fDzF_w6iJrQ?si=jVfQl5atylLfzqxJ')

  String videoUrl1 =

      //'https://www.youtube.com/watch?v=dIwPi6sX2uQ';
      'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
  //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
  @override
  int videoID = 0;
  void initState() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl1));
    _videoPlayerController.play();
    _chewieController = ChewieController(
        looping: true,
        autoPlay: true,
        startAt: const Duration(seconds: 0),
        videoPlayerController: _videoPlayerController,
        aspectRatio: 1);
    setState(() {});
    super.initState();
  }

  void loadProperties(String videoUrl) {
    _chewieController = ChewieController(
        autoPlay: true,
        startAt: const Duration(seconds: 0),
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(videoUrl)),
        aspectRatio: 1);
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    _bookmarkController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Your Favorite Course is Here "), actions: [
        IconButton(
            onPressed: () {
              _auth.signOut();
              Get.off(SignInScreen());
            },
            icon: Icon(
              Icons.logout,
            )),
      ]),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                width: 180,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("List of Content"),
                      Expanded(
                          child: MediaQuery.removePadding(
                        context: context,
                        removeRight: true,
                        child: ListView.builder(
                            itemCount: chapterList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  color: selectedIndex == index
                                      ? Colors.green
                                      : Colors.greenAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          //   videoUrl1 = videoUrl1;
                                          selectedIndex = index;
                                          loadProperties(videoUrl1);
                                        });
                                      },
                                      child: Text(chapterList[index].title)));
                            }),
                      )),
                    ]),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Chewie(controller: _chewieController),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (0 < selectedIndex) {
                                  selectedIndex--;
                                  loadProperties(videoUrl1);
                                }
                              });
                            },
                            child: const RoundButton(title: "Previous")),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (chapterList.length > selectedIndex + 1) {
                                  selectedIndex++;
                                  loadProperties(videoUrl1);
                                }
                              });
                            },
                            child: const RoundButton(title: "Next")),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            openBottomSheet(context);
                          },
                          child: RoundButton(
                            title: "Bookmark",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _chewieController.pause();
                            Get.to(BookmarksScreen(
                              videoId: selectedIndex,
                            ));
                          },
                          child: RoundButton(
                            title: "See all",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        showClaimCertificateMessage(context);
                      },
                      child: RoundButton(
                        title: "Certificate",
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Add your bottom sheet content here
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Book Mark Info'),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bookmarkController,
                decoration: InputDecoration(hintText: "Book Mark Info"),
              ),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    // Close the bottom sheet if needed
                    Navigator.of(context).pop();

                    _bookmarkController.clear();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    bookMarkController.addDataToFirestore(
                      videoID,
                      _videoPlayerController.value.position.toString(),
                      _bookmarkController.text.toString(),
                    );

                    Navigator.of(context).pop();
                    _bookmarkController.clear();
                  },
                  child: Text('Save'),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  void showClaimCertificateMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Congratulations! Claim Your Certificate'),
        action: SnackBarAction(
          label: 'Claim',
          onPressed: () {
            // Redirect to the dashboard or take appropriate action
            Navigator.of(context).pop(); // Close the Snackbar
            // Redirect logic here
          },
        ),
      ),
    );
  }
}

class DetailScreenForMobile extends StatefulWidget {
  int courseId;

  DetailScreenForMobile({super.key, required this.courseId});

  @override
  State<DetailScreenForMobile> createState() => _DetailScreenForMobileState();
}

class _DetailScreenForMobileState extends State<DetailScreenForMobile> {
  BookMarkController bookMarkController = BookMarkController();
  List<Bookmark> bookmarks = [];

  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController;

  //    Uri.parse('https://youtu.be/fDzF_w6iJrQ?si=jVfQl5atylLfzqxJ')

  String videoUrl1 =

      //'https://www.youtube.com/watch?v=dIwPi6sX2uQ';
      //'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
  @override
  int videoID = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _bookmarkController = TextEditingController();
  void initState() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl1));
    _videoPlayerController.play();
    _chewieController = ChewieController(
        looping: true,
        autoPlay: true,
        startAt: const Duration(seconds: 0),
        videoPlayerController: _videoPlayerController,
        aspectRatio: 1);
    setState(() {});
    super.initState();
  }

  void loadProperties(String videoUrl) {
    _chewieController = ChewieController(
        autoPlay: true,
        startAt: const Duration(seconds: 0),
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(videoUrl)),
        aspectRatio: 1);
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    _bookmarkController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BigText(
            text: "Your Favorite Course is Here ",
            size: 14,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _auth.signOut();
                  Get.off(SignInScreen());
                },
                icon: Icon(
                  Icons.logout,
                )),
          ]),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Container(
            height: 500,
            child: Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Chewie(controller: _chewieController),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (0 < selectedIndex) {
                                selectedIndex--;
                                videoID = selectedIndex + 1;

                                loadProperties(videoUrl1);
                              }
                            });
                          },
                          child: const RoundButton(title: "Previous")),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (chapterList.length > selectedIndex + 1) {
                                selectedIndex++;
                                videoID = selectedIndex + 1;
                                loadProperties(videoUrl1);
                              }
                            });
                          },
                          child: const RoundButton(title: "Next")),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            openBottomSheet(context);
                          });
                        },
                        child: RoundButton(
                          title: "Bookmark",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _chewieController.pause();
                          Get.to(BookmarksScreen(
                            videoId: selectedIndex,
                          ));
                        },
                        child: RoundButton(
                          title: "See all",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showClaimCertificateMessage(context);
                    },
                    child: RoundButton(
                      title: "Certificate",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Container(
        width: 200,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("List of Content"),
              Expanded(
                  child: MediaQuery.removePadding(
                context: context,
                removeRight: true,
                child: ListView.builder(
                    itemCount: chapterList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          color: selectedIndex == index
                              ? AppColors.paraColor
                              : Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  //   videoUrl1 = videoUrl1;
                                  selectedIndex = index;
                                  loadProperties(videoUrl1);
                                });
                              },
                              child: Text(chapterList[index].title)));
                    }),
              )),
            ]),
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Add your bottom sheet content here
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Book Mark Info'),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bookmarkController,
                decoration: InputDecoration(hintText: "Book Mark Info"),
              ),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    // Close the bottom sheet if needed
                    Navigator.of(context).pop();

                    _bookmarkController.clear();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    bookMarkController.addDataToFirestore(
                      videoID,
                      _videoPlayerController.value.position.toString(),
                      _bookmarkController.text.toString(),
                    );

                    Navigator.of(context).pop();
                    _bookmarkController.clear();
                  },
                  child: Text('Save'),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}

void showClaimCertificateMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Congratulations! Claim Your Certificate'),
      action: SnackBarAction(
        label: 'Claim',
        onPressed: () {
          // Redirect to the dashboard or take appropriate action
          Navigator.of(context).pop(); // Close the Snackbar
          // Redirect logic here
        },
      ),
    ),
  );
}

// void showBottomSheet2(BuildContext context, String duration, int videoId) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return BottomSheetContent(
//         duration: duration,
//         videoId: videoId,
//       );
//     },
//   );
// }

// class BottomSheetContent extends StatefulWidget {
//   final String duration;
//   final int videoId;
//   const BottomSheetContent(
//       {super.key, required this.duration, required this.videoId});

//   @override
//   State<BottomSheetContent> createState() => _BottomSheetContentState();
// }

// TextEditingController _bookmarkController = TextEditingController();
// BookMarkController bookMarkController = BookMarkController();

// class _BottomSheetContentState extends State<BottomSheetContent> {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       Container(
//         // Add your bottom sheet content here
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             Text('Book Mark Info'),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _bookmarkController,
//               decoration: InputDecoration(hintText: "Book Mark Info"),
//             ),
//             Row(children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Close the bottom sheet if needed
//                   Navigator.of(context).pop();

//                   _bookmarkController.clear();
//                 },
//                 child: Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Close the bottom sheet if needed
//                   // bookMarkController.saveBookMark(
//                   //   videoID,
//                   //   _videoPlayerController.value.position.toString(),
//                   //   _bookmarkController.text.toString(),
//                   // );

//                   bookMarkController.addDataToFirestore(widget.videoId,
//                       widget.duration, _bookmarkController.text.toString());
//                   Navigator.of(context).pop();
//                   _bookmarkController.clear();
//                 },
//                 child: Text('Save'),
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }
