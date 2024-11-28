import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmbi/config/aws_test.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

class FileAttachment extends StatefulWidget {
  final Function(List<ImageFile>?) onFileAttached;

  const FileAttachment({super.key, required this.onFileAttached});

  @override
  State<FileAttachment> createState() => _FileAttachmentState();
}

class _FileAttachmentState extends State<FileAttachment> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _imageFiles = [];
  final List<ImageFile> _imageFileList = [];
  final List<String> _imageFileNameList = [];
  bool isMultipleImageSelected = false;
  String totalImageSelected = "0";

  /// ACCESS NATIVE CODE \\\
  var channel = const MethodChannel("aws_service_channel");

  Future<void> awsService(List<String> files) async {
    try {
      var status = await channel.invokeMethod("upload_file", {'args': files});
      debugPrint("RESULT $status");
    } catch (e) {
      debugPrint("FLUTTER_AWS_ERROR:: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _attachmentButton(),
        SizedBox(
          width: Converts.c16,
        ),
        Expanded(child: _imageView())
      ],
    );
  }

  Widget _imageView() {
    return SizedBox(
      height: Converts.c72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Converts.c8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Converts.c16),
                  child: Image.file(
                    File(_imageFiles[index].path),
                    width: Converts.c72,
                    height: Converts.c72,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4.0, // Adjust the top position
                  right: 4.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _imageFiles.removeAt(index);
                        _imageFileList.removeAt(index);
                        // pass files
                        widget.onFileAttached(_imageFileList);
                        totalImageSelected = _imageFileList.length.toString();
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Palette.tabColor,
                      ),
                      child: Icon(
                        Icons.close,
                        size: Converts.c16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _attachmentButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMultipleImageSelected = true;
        });
        _captureImage();
      },
      onDoubleTap: () {
        setState(() {
          isMultipleImageSelected = true;
        });
        _pickImages();
      },
      child: Container(
        width: Converts.c72,
        height: Converts.c72,
        decoration: BoxDecoration(
          //color: Colors.orange,
          borderRadius: BorderRadius.all(
            Radius.circular(Converts.c16),
          ),
          border: Border.all(
            color: Palette.tabColor, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: !isMultipleImageSelected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: Converts.c24,
                    color: Palette.tabColor,
                  ),
                  TextViewCustom(
                      text: "($totalImageSelected/5)",
                      fontSize: Converts.c8,
                      tvColor: Palette.iconColor,
                      isRubik: false,
                      isBold: true),
                ],
              )
            : Center(
                child: SizedBox(
                  height: Converts.c16,
                  width: Converts.c16,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2, // Smaller stroke for a finer spinner
                    valueColor: AlwaysStoppedAnimation<Color>(Palette.tabColor),
                  ),
                ),
              ),
      ),
    );
  }

  Future<bool> _checkPermissions(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      debugPrint("GRANTED");
      return true;
    } else {
      debugPrint("DENIED");
      return false;
    }
  }

  Future<void> _captureImage() async {
    String staffId = await SPHelper().getUserInfo();
    if (await _checkPermissions(Permission.camera)) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // process selected image
        File file = File(image.path);
        Uint8List compressedBytes = await _processImage(file);
        //_imageFileList.add(ImageFile(compressedBytes, _fileName("340553")));
        _imageFileList.add(ImageFile(compressedBytes, _fileName(staffId)));

        setState(() {
          _imageFiles.add(image);
          // pass files
          widget.onFileAttached(_imageFileList);
          totalImageSelected = _imageFileList.length.toString();
          // hide loading
          isMultipleImageSelected = false;
        });
      } else {
        // hide loading
        setState(() {
          isMultipleImageSelected = false;
        });
      }
    }
  }

  Future<void> _pickImages() async {
    String staffId = await SPHelper().getUserInfo();
    bool isStoragePermission = true;
    bool isPhotosPermission = true;

    // check for photo permission only for android version 33
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        isPhotosPermission = await _checkPermissions(Permission.photos);
      } else {
        isStoragePermission = await _checkPermissions(Permission.storage);
      }
    } else {
      isStoragePermission = await _checkPermissions(Permission.storage);
    }
    // if all permission granted
    if (isPhotosPermission && isStoragePermission) {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        // if more than 5 images are selected
        List<XFile> limitedImages = selectedImages.length > 5
            ? selectedImages.sublist(0, 5) // to get the first 5 images
            : selectedImages;
        // process selected image
        for (var image in limitedImages) {
          File file = File(image.path);
          Uint8List compressedBytes = await _processImage(file);
          //_imageFileList.add(ImageFile(compressedBytes, _fileName("340553")));
          _imageFileList.add(ImageFile(compressedBytes, _fileName(staffId)));
        }
        setState(() {
          _imageFiles.addAll(limitedImages);
          // pass files
          widget.onFileAttached(_imageFileList);
          totalImageSelected = _imageFileList.length.toString();
          // hide loading
          isMultipleImageSelected = false;
        });
      } else {
        // hide loading
        setState(() {
          isMultipleImageSelected = false;
        });
      }
    }
  }

  /*Future<Uint8List> _processImage(File imageFile,
      {minWidth = 800, minHeight = 800, quality = 50}) async {
    try {
      // Step 1: read image as bytes and decode
      img.Image? image = img.decodeImage(await imageFile.readAsBytes());

      if (image != null) {
        // Step 2: resize the image (keep aspect ratio)
        img.Image resizedImage =
            img.copyResize(image, width: minWidth, height: minHeight);

        // Step 3: compress the image (JPEG format, quality set for reasonable compression)
        Uint8List resizedBytes =
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));

        // Step 4: optionally, compress further using `flutter_image_compress`
        return await _compressImage(resizedBytes);
      }
    } catch (e) {
      debugPrint("ERROR::${e.toString()}");
      return await imageFile.readAsBytes();
    }
    return await imageFile.readAsBytes();
  }

  Future<Uint8List> _compressImage(Uint8List imageBytes,
      {minWidth = 800, minHeight = 800, quality = 50}) async {
    var result = await FlutterImageCompress.compressWithList(imageBytes,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
        format: CompressFormat.jpeg);
    return result;
  }*/

  Future<Uint8List> _processImage(File imageFile, {quality = 80}) async {
    try {
      // read image as bytes
      List<int> imageBytes = await imageFile.readAsBytes();
      // convert List<int> to Uint8List
      Uint8List uint8ListImageBytes = Uint8List.fromList(imageBytes);
      // decode image to check the image properties
      img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

      if (image != null) {
        // compress the image without resizing
        // for better file size reduction
        Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
          uint8ListImageBytes,
          quality: quality,
          format: CompressFormat.jpeg,
        );
        // save image into local
        //awsService(["image/abc.jpg", "image/123.jpg"]);
        //_saveIntoLocalDir(compressedBytes);
        _saveIntoExternalDirectory(compressedBytes);
        return compressedBytes;
      }
    } catch (e) {
      debugPrint("ERROR::${e.toString()}");
    }
    // return original image if something goes wrong
    return await imageFile.readAsBytes();
  }

  Future<void> _saveIntoLocalDir(Uint8List compressedBytes,
      {String folderName = "track_all"}) async {
    try {
      String staffId = await SPHelper().getUserInfo();
      // get the directory for app-specific documents
      Directory directory = await getApplicationDocumentsDirectory();
      String folderPath = "${directory.path}/$folderName";
      debugPrint("IMAGE_PATH: $folderPath");
      // create a Directory instance for the folder
      Directory folder = Directory(folderPath);
      // folder doesn't exist, create it recursively
      if (!await folder.exists()) {
        await folder.create(
            recursive: true); // Ensure all parent directories are created
      }
      // define file path to save the image using the actual folder path
      String fileName = _fileName(staffId);
      String imagePath = '${folder.path}/$fileName'; // Use folder.path here
      debugPrint("Final IMAGE_PATH: $imagePath");

      /// Test start
      // Get external storage directory (compatible with both API 29 and below)
      Directory? externalDirectory = await getExternalStorageDirectory();
      String externalFilePath = '${externalDirectory!.path}/$fileName';
      File copyFile = File(externalFilePath);

      /// Test End
      // save the compressed image to the local path
      File file = File(imagePath);
      await file.writeAsBytes(compressedBytes);

      /// TEST START
      await file.copy(copyFile.path);

      /// TEST END
      debugPrint("File saved at: $imagePath");
      debugPrint("File copy at: ${copyFile.path}");
    } catch (e) {
      debugPrint("FILE_ERROR: ${e.toString()}");
    }
  }

  Future<void> _saveIntoExternalDirectory(Uint8List compressedBytes) async {
    try {
      String staffId = await SPHelper().getUserInfo();
      String fileName = _fileName(staffId);
      Directory? externalDirectory = await getExternalStorageDirectory();
      String externalFilePath = '${externalDirectory!.path}/$fileName';
      File file = File(externalFilePath);
      await file.writeAsBytes(compressedBytes);
      _imageFileNameList.add(file.path);
      // test
      awsService(_imageFileNameList);
      debugPrint("File saved at: ${file.path}");
    } catch(e) {
      debugPrint("FILE_ERROR: ${e.toString()}");
    }
  }

  String _fileName(String userId, {String type1 = "5", String type2 = "img"}) {
    final DateTime dateTime = DateTime.now();
    return "$type1${dateTime.year.toString().substring(2, 4)}${dateTime.month.toString().padLeft(2, '0')}_${userId}_${dateTime.millisecondsSinceEpoch}_$type2.jpg";
  }

}

class ImageFile {
  Uint8List file;
  String name;

  ImageFile(this.file, this.name);
}
