
/*
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../../models/new_task/upload_response.dart';
import '../../models/new_task/visiting_card_data.dart';
import '../../screens/new_task/card_scan_screen.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? controller;

  final boxWidth = 300.0;
  final boxHeight = 200.0;
  bool isReady = false;
  XFile? capturedImage;

  double uploadProgress = 0.0; // 0.0 → 1.0
  bool isUploading = false;
  Timer? _progressTimer;

  VisitingCardData? _cardData;
  VisitingCardData? get cardData => _cardData;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();
    isReady = true;
    notifyListeners();
  }

  Future<void> captureImage(BuildContext context) async {
    if (!controller!.value.isInitialized) return;
    capturedImage = await controller!.takePicture();
    _cardData = null;
    notifyListeners();

    if (capturedImage != null) {
      //await uploadImage(staffId: "340553", uniqueId: "123456");
      final file = File(capturedImage!.path);
      String text = await extractTextFromImage(file);
      debugPrint("Raw: $text");
      //final card = parseVisitingCard(text);
      _cardData = parseVisitingCard(text);
      showReviewDetailsDialog(context);
      //debugPrint("name: ${card.name}");
      //debugPrint("mobile: ${card.mobile}");
      //debugPrint("email: ${card.email}");
      //debugPrint("website: ${card.website}");
      //debugPrint("company: ${card.company}");
      //debugPrint("extra: ${card.extraText}");
    }
  }

  void retake() {
    capturedImage = null;
    notifyListeners();
  }


  // upload image with smooth progress
  Future<void> uploadImage({
    required String staffId,
    required String uniqueId,
  }) async
  {
    if (capturedImage == null) return;

    final file = File(capturedImage!.path);

    isUploading = true;
    uploadProgress = 0.0;
    notifyListeners();

    // smooth simulated progress (increments every 0.5 sec)
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (uploadProgress < 0.8) {
        uploadProgress += 0.01; // increase 1% every 0.5 sec
        notifyListeners();
      } else {
        timer.cancel(); // stop at 80%
      }
    });

    try {      // HTTP upload
      final request = http.MultipartRequest('POST', Uri.parse("http://rfq.prangroup.com//Vendor/vdcv/ExtractTextV2"));
      request.fields['staffId'] = staffId;
      request.fields['uniqueId'] = uniqueId;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        //capturedImage!.path,
        file.path,
        contentType: http.MediaType('image', 'jpeg'), // send as JPEG
      ));

      final response = await request.send();

      // Cancel simulated progress if still running
      _progressTimer?.cancel();

      if (response.statusCode == 200) {
        uploadProgress = 1.0; // 100%
        notifyListeners();
        final respStr = await response.stream.bytesToString();
        final uploadResponse = UploadResponse.fromJson(respStr);
        debugPrint('Upload success: $respStr');
      } else {
        isUploading = false;
        notifyListeners();
        throw Exception('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      _progressTimer?.cancel();
      isUploading = false;
      notifyListeners();
      rethrow;
    } finally {
      isUploading = false;
      _progressTimer?.cancel();
      notifyListeners();
    }
  }

  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    textRecognizer.close();
    return recognizedText.text;
  }

  void resetProgress() {
    uploadProgress = 0.0;
    notifyListeners();
  }

  Future<void> showReviewDetailsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReviewDetailsFullScreen(
        cardData: _cardData!,
        file: File(capturedImage!.path),
        height: boxHeight,
        width: boxWidth,
      ),
    );
  }

  @override
  void dispose() {
    if (controller != null) controller!.dispose();
    super.dispose();
  }

}
*/