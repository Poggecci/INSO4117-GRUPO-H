import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/globals.dart';
import 'models/post.dart';

class VolunteerHome extends StatefulWidget {
  const VolunteerHome({super.key});

  @override
  _VolunteerHomeState createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  late List<ViewPost> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [
      ViewPost(
          id: "1",
          shelterId: "2",
          shelterName: "Puerto Rico Stray Helpers",
          title: "4 dogs need temporary homes",
          description:
              "Our shelter recently hit capacity and we just had 4 new strays be brought in. We are looking for individuals willing to take in some of our dogs up for adoption for a brief period whilst more adoptions come in and we return to operating below capacity.",
          needs: const ["bridge"],
          createdAt: Timestamp.now(),
          visibleTo: const ["sBMQuu4m4lhoEDlcmQ6QyxsFaRC2"])
    ];
  }

  Future<void> _refreshPosts() async {
    // Fetch the latest posts from Firestore
    final db = FirebaseFirestore.instance;
    final volunteerID = Globals.userID;
    final visiblePosts = db
        .collection("posts")
        .where('visibleTo', arrayContains: volunteerID)
        .orderBy('createdAt');
    final fireStorePosts = (await visiblePosts.get()).docs;
    final latestPosts = fireStorePosts.map((e) => Post.fromFirestore(e, null));
    final shelterIDs = latestPosts.map((post) => post.shelterId).toList();
    final idToName = Map.fromEntries((await db
            .collection("users")
            .where("type", isEqualTo: "Shelter")
            .where('id', whereIn: shelterIDs)
            .get())
        .docs
        .map((shelter) => MapEntry(shelter.id, shelter.get("name"))));
    final latestViewPosts = latestPosts.map((post) {
      return ViewPost(
          id: post.id,
          shelterId: post.shelterId,
          shelterName: idToName[post.shelterId],
          title: post.title,
          description: post.description,
          needs: post.needs,
          createdAt: post.createdAt,
          visibleTo: post.visibleTo);
    });
    print('Refreshed Posts.');

    // Update the state of the widget with the latest posts
    setState(() {
      _posts = latestViewPosts.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetails(post: _posts[index]),
                  ),
                );
              },
              child: ListTile(
                title: Text(_posts[index].title),
                subtitle: Text(_posts[index].shelterName),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PostDetails extends StatelessWidget {
  final ViewPost post;

  const PostDetails({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              post.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Needs: ${post.needs.join(", ")}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Needs: ${post.shelterName}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Created: ${post.createdAt}',
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
