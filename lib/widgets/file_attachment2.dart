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
import 'package:tmbi/viewmodel/inquiry_create_viewmodel.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';
import 'file_attachment.dart';

class FileAttachment2 extends StatefulWidget {
  //final Function(List<ImageFile>?) onFileAttached;

  const FileAttachment2({
    super.key,
    //required this.onFileAttached,
  });

  @override
  State<FileAttachment2> createState() => _FileAttachment2State();
}

class _FileAttachment2State extends State<FileAttachment2> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isLoading
            ? SizedBox(
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
              )
            : Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: Converts.c16,
                    //color: _imageFiles.isNotEmpty
                    color: context
                            .read<InquiryCreateViewModel>()
                            .imageFiles
                            .isNotEmpty
                        ? Palette.mainColor
                        : Palette.semiTv,
                  ),
                  onPressed: () {
                    _captureImage();
                  },
                ),
              ),
        //if (_imageFiles.isNotEmpty) const VerticalDivider(),
        if (context.read<InquiryCreateViewModel>().imageFiles.isNotEmpty)
          const VerticalDivider(),
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
          itemCount: context.read<InquiryCreateViewModel>().imageFiles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: Converts.c8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Converts.c8),
                    child: Image.memory(
                      context
                          .read<InquiryCreateViewModel>()
                          .imageFiles[index]
                          .file,
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
                          context
                              .read<InquiryCreateViewModel>()
                              .deleteImageFile(index);
                          /*widget.onFileAttached(context
                              .read<InquiryCreateViewModel>()
                              .imageFiles);*/
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
      return true;
    } else {
      return false;
    }
  }

  Future<void> _checkCameraPermission() async {
    final permissionStatus = await _checkPermissions(Permission.camera);
    if (!permissionStatus) {
      showMessage(Strings.cameraPermissionRequired);
    }
  }

  Future<void> _captureImage() async {
    String staffId = await SPHelper().getUserInfo();
    if (await _checkPermissions(Permission.camera)) {
      setState(() => isLoading = true);

      try {
        final XFile? image =
            await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          File file = File(image.path);
          Uint8List compressedBytes = await _processImage(file);

          setState(() {
            context
                .read<InquiryCreateViewModel>()
                .setImageFile(ImageFile(compressedBytes, _fileName(staffId)));
            /*widget.onFileAttached(
                context.read<InquiryCreateViewModel>().imageFiles);*/
          });
        }
      } catch (e) {
        debugPrint("Error capturing image: $e");
        showMessage(Strings.errorCaptureImage);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<Uint8List> _processImage(File imageFile, {int quality = 50}) async {
    try {
      // read image as bytes
      Uint8List imageBytes = await imageFile.readAsBytes();
      // decode image to check if it's valid
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception(Strings.failedToDecodeImage);
      }
      // compress the image with the specified quality (without resizing)
      return await FlutterImageCompress.compressWithList(
        imageBytes,
        quality: quality,
        format: CompressFormat.jpeg,
      );
    } catch (e) {
      debugPrint("ERROR::${e.toString()}");
      // return the original image bytes in case of an error
      return imageFile.readAsBytes();
    }
  }



  String _fileName(String userId, {String type1 = "5", String type2 = "img"}) {
    final DateTime dateTime = DateTime.now();
    return "$type1${dateTime.year.toString().substring(2, 4)}${dateTime.month.toString().padLeft(2, '0')}_${userId}_${dateTime.millisecondsSinceEpoch}_$type2.jpg";
  }

  void showMessage(String message) {
    final snackBar = SnackBar(
      content: TextViewCustom(
        text: message,
        tvColor: Colors.white,
        fontSize: Converts.c16,
        isBold: false,
        isRubik: true,
        isTextAlignCenter: false,
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
//376427