/*
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadManager {
  Future<void> pickCompressAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      File? compressFile = await _compressImage(imageFile);

      if (compressFile != null) {
        //await _uploadImageIntoFirebase(compressFile);
        await _uploadImageToServer(compressFile);
      }else {
        debugPrint("Image compression failed");
      }
    }
  }

  // image compression
  Future<File?> _compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minHeight: 800,
      minWidth: 800,
      quality: 85,
      rotate: 0,
    );
    if (result != null) {
      return File.fromRawPath(result);
    }
    return null;
  }

  // upload image to firebase storage
  Future<void> _uploadImageIntoFirebase(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String filePath = 'track_all_assets/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child(filePath);
      // upload
      await ref.putFile(file);
      debugPrint("Image uploaded successfully");
    } catch (e) {
      debugPrint("Error:: $e");
    }
  }

  // Upload the compressed image to the server
  Future<void> _uploadImageToServer(File imageFile) async {
    try {
      var uri = Uri.parse("http://swift.prangroup.com:8521/alphan/ImageUpload/upload/"); // Replace with your server's URL
      var request = http.MultipartRequest("POST", uri);

      // Attach the image file as a multipart
      var pic = await http.MultipartFile.fromPath("files", imageFile.path);
      request.files.add(pic);

      // You can add additional fields to the request if needed
      request.fields['challanno'] = 'XXXX';  // Example of additional data
      request.fields['dbid'] = 'RFL';  // Example of additional data

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image uploaded successfully");
      } else {
        print("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }


  // Background task setup using background_fetch
  void setupBackgroundTask() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // Run every 15 minutes (you can adjust this)
        stopOnTerminate: false,    // Continue running after app is terminated
        enableHeadless: true,      // Enable headless task execution

      ), (String taskId) async {
      // This will run when a background task is triggered
      debugPrint("Running background task...");

      // Perform image compression and upload
      await pickCompressAndUploadImage();

      // Finish the background task
      BackgroundFetch.finish(taskId);
      debugPrint("Task end");
    },
    );
  }

  // Function to run background tasks even when the app is terminated
  static void backgroundFetchHeadlessTask() {
    debugPrint("Headless background task executed");

    // Create instance of ImageUploadManager and call the upload function
    ImageUploadManager manager = ImageUploadManager();
    manager.pickCompressAndUploadImage();
  }

}
*/
