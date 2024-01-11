import 'package:image_picker/image_picker.dart';

pickvideo_gallery() async{
  final picker=ImagePicker();
  XFile? videoFile;
  try {
    videoFile = await picker.pickVideo(source: ImageSource.gallery);
    return videoFile!.path;
  } catch (e) {
    print(e);
  }
}
pickvideo_cam() async{
  final picker=ImagePicker();
  XFile? videoFile;
  try {
    videoFile = await picker.pickVideo(source: ImageSource.camera);
    return videoFile!.path;
  } catch (e) {
    print(e);
  }
}
