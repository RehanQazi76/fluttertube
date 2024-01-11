import 'package:fluttertube/screens/uploadData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class VideoDisplayPage extends StatefulWidget {
  @override
  State<VideoDisplayPage> createState() => _VideoDisplayPageState();
}

class _VideoDisplayPageState extends State<VideoDisplayPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _query= TextEditingController();

  String? searchQuery ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Display'),
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _query,
                      keyboardType: TextInputType.text,
                      
                      decoration: InputDecoration(
                        hintText: "Search by Category..",
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    searchQuery = _query.text.toString();
                    setState(() {
                      
                    });
                    _query.clear();
                  },
                  child: Text("Search"),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:(searchQuery != null && searchQuery!.isNotEmpty)
                  ? _firestore
                      .collection('videos')
                      .where('category', isEqualTo: searchQuery)
                      .snapshots()
                  : _firestore.collection('videos').snapshots(),             
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data?.docs.isEmpty ?? true) {
                  return Center(
                    child: Text('No videos available.'),
                  );
                }

                return ListView.builder(
                  itemCount:snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot<Map<String, dynamic>> document =
                        snapshot.data!.docs[index];
                    return VideoWidget(document);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>uploadData()));
      },
      child: Icon(Icons.add),
      shape:CircleBorder(eccentricity: 0.5) ,
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  VideoWidget(this.document);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}
// ... (previous code remains unchanged)

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    String videoUrl = widget.document['url'];
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..addListener(() {
        if (_videoController.value.hasError) {
          print('VideoPlayerController error: ${_videoController.value.errorDescription}');
        }
      });

    _initializeVideoPlayerFuture = _videoController.initialize();
    _isPlaying = true; // Assume the video starts playing initially
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Title: ${widget.document['title']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text('Description: ${widget.document['description']}',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 8.0),
          Text('Location: ${widget.document['location']}',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 8.0),
          Text('Category: ${widget.document['category']}',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 16.0),
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: _videoController.value.isInitialized
                      ? Column(
                          children: [
                            AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                            SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: _togglePlayPause,
                              child: Text(_isPlaying ? 'Pause' : 'Play'),
                            ),
                          ],
                        )
                      : CircularProgressIndicator(),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
