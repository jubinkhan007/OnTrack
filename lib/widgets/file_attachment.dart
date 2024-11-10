import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';

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
        _captureImage();
      },
      onDoubleTap: () {
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
        child: Icon(
          Icons.add_a_photo,
          size: Converts.c24,
          color: Palette.tabColor,
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
    if (await _checkPermissions(Permission.camera)) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // process selected image
        File file = File(image.path);
        Uint8List compressedBytes = await _processImage(file);
        _imageFileList.add(ImageFile(compressedBytes, _fileName("340553")));

        setState(() {
          _imageFiles.add(image);
          // pass files
          widget.onFileAttached(_imageFileList);
        });
      }
    }
  }

  Future<void> _pickImages() async {
    if (await _checkPermissions(Permission.storage)) {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        // process selected image
        for (var image in selectedImages) {
          File file = File(image.path);
          Uint8List compressedBytes = await _processImage(file);
          _imageFileList.add(ImageFile(compressedBytes, _fileName("340553")));
        }

        setState(() {
          _imageFiles.addAll(selectedImages);
          // pass files
          widget.onFileAttached(_imageFileList);
        });
      }
    }
  }

  Future<Uint8List> _processImage(File imageFile,
      {minWidth = 800, minHeight = 800, quality = 50}) async {
    // Step 1: read image as bytes and decode
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    if (image != null) {
      // Step 2: resize the image (keep aspect ratio)
      img.Image resizedImage =
          img.copyResize(image, width: minWidth, height: minHeight);

      // Step 3: compress the image (JPEG format, quality set to 85 for reasonable compression)
      Uint8List resizedBytes =
          Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));

      // Step 4: optionally, compress further using `flutter_image_compress`
      return await _compressImage(resizedBytes);
    }
    throw Exception("Failed to decode image.");
  }

  Future<Uint8List> _compressImage(Uint8List imageBytes,
      {minWidth = 800, minHeight = 800, quality = 50}) async {
    var result = await FlutterImageCompress.compressWithList(imageBytes,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
        format: CompressFormat.jpeg);
    return result;
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
