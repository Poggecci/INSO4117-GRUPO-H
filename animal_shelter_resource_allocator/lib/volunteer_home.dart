import 'package:flutter/material.dart';

import 'models/post.dart';

class VolunteerHome extends StatefulWidget {
  const VolunteerHome({super.key});

  @override
  _VolunteerHomeState createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [
      const Post(
          id: "1",
          shelterName: "Puerto Rico Stray Helpers",
          title: "4 dogs need temporary homes",
          description:
              "Our shelter recently hit capacity and we just had 4 new strays be brought in. We are looking for individuals willing to take in some of our dogs up for adoption for a brief period whilst more adoptions come in and we return to operating below capacity.",
          needs: ["bridge"])
    ];
  }

  Future<void> _refreshPosts() async {
    // Fetch the latest posts from your data source (e.g. Firestore)
    List<Post> latestPosts = _posts; //TODO: Implement
    print('Refreshed Posts.');

    // Update the state of the widget with the latest posts
    setState(() {
      _posts = latestPosts;
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
                subtitle: Text(_posts[index].description),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PostDetails extends StatelessWidget {
  final Post post;

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
          ],
        ),
      ),
    );
  }
}
