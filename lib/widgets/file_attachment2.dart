import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/main.dart';
import 'package:tmbi/viewmodel/inquiry_create_viewmodel.dart';

import 'file_attachment.dart';

class FileAttachment2 extends StatefulWidget {
  final Function(List<ImageFile>?) onFileAttached;

  FileAttachment2({
    super.key,
    required this.onFileAttached,
  });

  @override
  State<FileAttachment2> createState() => _FileAttachment2State();
}

class _FileAttachment2State extends State<FileAttachment2> {
  final ImagePicker _picker = ImagePicker();
  //final List<ImageFile> _imageFiles = [];
  bool isMultipleImageSelected = false;
  String totalImageSelected = "0";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        !isMultipleImageSelected
            ? Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: Converts.c16,
                    //color: _imageFiles.isNotEmpty
                    color: context.read<InquiryCreateViewModel>().imageFiles.isNotEmpty
                        ? Palette.mainColor
                        : Palette.semiTv,
                  ),
                  onPressed: () {
                    setState(() {
                      isMultipleImageSelected = true;
                    });
                    _captureImage();
                  },
                ),
              )
            : SizedBox(
                height: Converts.c48,
                width: Converts.c48,
                child: Center(
                  child: SizedBox(
                    height: Converts.c16,
                    width: Converts.c16,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2, // Smaller stroke for a finer spinner
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Palette.tabColor),
                    ),
                  ),
                ),
              ),
        //if (_imageFiles.isNotEmpty) const VerticalDivider(),
        if (context.read<InquiryCreateViewModel>().imageFiles.isNotEmpty) const VerticalDivider(),
        Expanded(child: _imageViewTodo()),
      ],
    );
  }

  Widget _imageViewTodo() {
    return Center(
      child: SizedBox(
        height: Converts.c48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: _imageFiles.length,
          itemCount: context.read<InquiryCreateViewModel>().imageFiles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: Converts.c8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Converts.c8),
                    child: Image.memory(
                      //_imageFiles[index].file,
                      context.read<InquiryCreateViewModel>().imageFiles[index].file,
                      width: Converts.c48,
                      height: Converts.c48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4.0, // Adjust the top position
                    right: 4.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          //_imageFiles.removeAt(index);
                          context.read<InquiryCreateViewModel>().deleteImageFile(index);
                          // pass files
                          //widget.onFileAttached(_imageFiles);
                          widget.onFileAttached(context.read<InquiryCreateViewModel>().imageFiles);
                          //totalImageSelected = _imageFiles.length.toString();
                          totalImageSelected = context.read<InquiryCreateViewModel>().imageFiles.length.toString();
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

        setState(() {
          //_imageFiles.add(ImageFile(compressedBytes, _fileName(staffId)));
          context.read<InquiryCreateViewModel>().setImageFile(ImageFile(compressedBytes, _fileName(staffId)));
          //_imageFiles.add(image);
          // pass files
          //widget.onFileAttached(_imageFiles);
          widget.onFileAttached(context.read<InquiryCreateViewModel>().imageFiles);
          //totalImageSelected = _imageFiles.length.toString();
          totalImageSelected = context.read<InquiryCreateViewModel>().imageFiles.length.toString();
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
        return compressedBytes;
      }
    } catch (e) {
      debugPrint("ERROR::${e.toString()}");
    }
    // return original image if something goes wrong
    return await imageFile.readAsBytes();
  }

  String _fileName(String userId, {String type1 = "5", String type2 = "img"}) {
    final DateTime dateTime = DateTime.now();
    return "$type1${dateTime.year.toString().substring(2, 4)}${dateTime.month.toString().padLeft(2, '0')}_${userId}_${dateTime.millisecondsSinceEpoch}_$type2.jpg";
  }
}
