import 'package:cs310socialmedia/feedCard.dart';
import 'package:cs310socialmedia/postCard.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/utils/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'model/post.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cs310socialmedia/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310socialmedia/login.dart';



//final usersRef = Firestore.instance.collection('Person');

class FeedView extends StatefulWidget {
  final User2 currentUser;

  const FeedView({Key key, this.currentUser, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  /*User2 user= new User2(id:"1",userName:"Arienne Tracey",photoUrl:"https://randomuser.me/api/portraits/women/71.jpg", bio:" ",email: "ex@mail.com");
  User2 user2= new User2(id:"2",userName:"Selwyn Skyler",photoUrl:"https://randomuser.me/api/portraits/men/43.jpg", bio:" ",email: "ex@mail.com");
  User2 user3= new User2(id:"2",userName:"Xia Cheng",photoUrl:"https://randomuser.me/api/portraits/women/90.jpg", bio:" ",email: "ex@mail.com");

  Post post = new Post(location:'Switzerland',text: 'Beautiful Nature #travel', date: '1h ago', likes: 350,dislikes: 5, imageUrl: 'https://cdn.pixabay.com/photo/2016/09/19/22/46/lake-1681485_1280.jpg', comments: 15);
  Post post2 = new Post(location:'Germany',text: 'Working #meetings', date: '15 March', likes: 110,dislikes: 14, imageUrl:'https://cdn.pixabay.com/photo/2016/06/03/13/57/digital-marketing-1433427_1280.jpg' , comments: 23);
  Post post3 = new Post(location:'China',text: 'Love eating ', date: '14 March', likes: 230,dislikes: 2, imageUrl:'https://cdn.pixabay.com/photo/2017/08/08/09/44/food-photography-2610863_1280.jpg' , comments: 7);*/

  List<PostCard> posts = [];

  @override
  void initState() {
    super.initState();
    getTimeline();
  }
  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    posts = snapshot.docs.map((doc) => PostCard.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }
  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Text("No posts");
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Poffertjes'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
          onRefresh: () => getTimeline(), child: buildTimeline()),
    );

  }


}