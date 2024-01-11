import 'dart:io';
import 'package:fluttertube/services/upload_video.dart';
import 'package:fluttertube/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import '../widgets/InputField.dart';
import 'package:geocoding/geocoding.dart';

class uploadData extends StatefulWidget {
  uploadData({super.key});

  @override
  State<uploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<uploadData> {
  TextEditingController title=TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  String? _url;
  String? _downloadUrl;
  VideoPlayerController? _controller;
  String? address;
  _pickvideo_cam()async {
    _url = await pickvideo_cam();
    _initalizePlayer();
  }
  _pickvideo_gallery()async {
    _url = await pickvideo_gallery();
    _initalizePlayer();
  }
  void _initalizePlayer(){
  _controller = VideoPlayerController.file(
    File(_url!))
    ..initialize().then((_){
      setState(() {
        _controller!.play();
      });
    } )
    ;

}

Widget _videoPlayer(){
  if(_controller!=null){
    return AspectRatio(aspectRatio: _controller!.value.aspectRatio,
    child: VideoPlayer(_controller!),
    );
  }
  else{
    return CircularProgressIndicator();
  }
}
void _uploadData()async{
  _downloadUrl= await StoreData().uploadVideo(_url!);
  await StoreData().saveVideoData(VideodownlodedUrl: _downloadUrl,
  Title: title.text.toString(),
  Description: description.text.toString(),
  location: address,
   Category: category.text.toString());
  
}
void _getUserLocation() async {
  LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    // Reverse geocoding to get the city name
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    address= placemarks.isNotEmpty ? placemarks[0].locality ?? '' : '';
    print('User Location: ${position.latitude}, ${position.longitude}, City: $address');
  } catch (e) {
    print('Error getting user location: $e');
  }
}


  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
              width: double.infinity,
            ),
            Center(
              child: Text(
                "Upload the Data",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            InputField(
              InputController: title,
              keyboardtype: TextInputType.text,
              hintText: "Enter the Title",
              icon: Icon(Icons.text_fields),
            ),


            ElevatedButton(
              onPressed: () async {
                await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40,
                                top: -40,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ),
                              
                              Column(
                                children: [
                                  ElevatedButton(onPressed: ()async{
                                    await _pickvideo_gallery();
                                    
                                  }, 
                                  child: Text("Upload from gallery")),
                                  ElevatedButton(onPressed: ()async{
                                await _pickvideo_cam();
                                
                              }, 
                              child: Text("Upload from Camera")),
                                ],
                              ),
                              

                            ],
                          ),
                        ));
              },
              child: const Text('Upload Video'),
            ),
            Center(
                  child: _url!=null?
                  _videoPlayer():Text("No video selected")
                ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: description,
                style: TextStyle(height: 2.0),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter Description",
                  suffixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                
                maxLines: 3,
              ),
            ),
            ElevatedButton(
              style:ButtonStyle(
                fixedSize:MaterialStatePropertyAll(Size(200,50)),       
              ),
              onPressed: () {
                // Call the function to get the user's location
                _getUserLocation();
                
              },
              child: const Text('Get User Location'),
            ),
            InputField(
              InputController: category,
              keyboardtype: TextInputType.text,
              hintText: "Enter Category",
              icon: Icon(Icons.text_fields),
            ),
            ElevatedButton(onPressed: () async{
              _uploadData();
              print(" chalra");
              
            },
             child: Text("Post it!")),
             TextButton(onPressed: (){
              setState(() {
                print("object");
                  print(description.text);
                  _url=null;
                  title.clear();
                  description.clear();
                  category.clear();
                  print(description.text);
                });
             }, child: Text("clear")),
             
          ],
        ),
      ),
    );
  }
}


