import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/extension_file.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/config/sp_helper.dart';
import 'package:tmbi/viewmodel/inquiry_create_viewmodel.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';
import '../models/image_file.dart';
import '../network/ui_state.dart';

class FileAttachment2 extends StatefulWidget {
  //final Function(List<ImageFile>?) onFileAttached;
  final InquiryCreateViewModel? inquiryViewModel;

  const FileAttachment2({
    super.key,
    required this.inquiryViewModel,
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
    //_checkCameraPermission();
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
                  icon: GestureDetector(
                    onLongPress: () {
                      _pickImages();
                    },
                    child: Icon(
                      Icons.image_outlined,
                      size: Converts.c16,
                      //color: _imageFiles.isNotEmpty
                      color: //context.read<InquiryCreateViewModel>()
                          widget.inquiryViewModel!.imageFiles.isNotEmpty
                              ? Palette.mainColor
                              : Palette.semiTv,
                    ),
                  ),
                  onPressed: () {
                    if (widget.inquiryViewModel != null) {
                      if (widget.inquiryViewModel!.imageFiles.length < 5) {
                        _captureImage();
                      } else {
                        showMessage(Strings.upToFiveImages);
                      }
                    }
                  },
                ),
              ),
        //if (context.read<InquiryCreateViewModel>().imageFiles.isNotEmpty)
        if (widget.inquiryViewModel!.imageFiles.isNotEmpty)
          const VerticalDivider(),
        Expanded(child: _imageViewTodo()),
      ],
    );
  }

  Widget _imageViewTodo() {
    //debugPrint("COUNT::${widget.inquiryViewModel!.imageFiles.length}");
    return Center(
      child: SizedBox(
        height: Converts.c48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: context.read<InquiryCreateViewModel>().imageFiles.length,
          itemCount: widget.inquiryViewModel!.imageFiles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: Converts.c8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Converts.c8),
                    child: Image.memory(
                      //context.read<InquiryCreateViewModel>()
                      widget.inquiryViewModel!.imageFiles[index].file,
                      width: Converts.c48,
                      height: Converts.c48,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// remove button
                  Positioned(
                    top: 4.0, // Adjust the top position
                    right: 4.0,
                    child: GestureDetector(
                      onTap: () {
                        widget.inquiryViewModel!.deleteImageFile(index);
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

                  /// counter view
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        color: Palette.tabColor.withOpacity(.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Converts.c8),
                          // Adjust the value as needed
                          bottomRight: Radius.circular(
                              Converts.c8), // Adjust the value as needed
                        ),
                      ),
                      child: TextViewCustom(
                        text: widget.inquiryViewModel != null
                            ? "${widget.inquiryViewModel!.imageFiles.length}/5"
                            : "",
                        tvColor: Colors.white,
                        fontSize: 8,
                        isRubik: true,
                        isBold: true,
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
    //if (await _checkPermissions(Permission.camera)) {
      //setState(() => isLoading = true);
      widget.inquiryViewModel!.uiState = UiState.loading;
      isLoading = widget.inquiryViewModel!.uiState == UiState.loading;

      try {
        final XFile? image =
            await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          File file = File(image.path);
          Uint8List compressedBytes = await _processImage(file);

          //setState(() {
          //context.read<InquiryCreateViewModel>()
          widget.inquiryViewModel!
              .setImageFile(ImageFile(compressedBytes, _fileName(staffId)));
          /*widget.onFileAttached(
                context.read<InquiryCreateViewModel>().imageFiles);*/
          //});
        }
      } catch (e) {
        debugPrint("Error capturing image: $e");
        showMessage(Strings.errorCaptureImage);
      } finally {
        //setState(() => isLoading = false);
        widget.inquiryViewModel!.uiState = UiState.success;
        isLoading = widget.inquiryViewModel!.uiState == UiState.loading;
      }
    //}
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

  Future<void> _pickImages() async {
    String staffId = await SPHelper().getUserInfo();
    bool isStoragePermission = true;
    bool isPhotosPermission = true;

    // check for photo permission only for Android version 33 and above
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

    // if all permissions are granted
    if (isPhotosPermission && isStoragePermission) {
      //setState(() => isLoading = true);
      widget.inquiryViewModel!.uiState = UiState.loading;
      isLoading = widget.inquiryViewModel!.uiState == UiState.loading;
      try {
        final List<XFile>? selectedImages = await _picker.pickMultiImage();
        if (selectedImages != null && selectedImages.isNotEmpty) {
          List<XFile> limitedImages = selectedImages.length > 5
              ? selectedImages.sublist(0, 5)
              : selectedImages;
          for (var image in limitedImages) {
            File file = File(image.path);
            Uint8List compressedBytes = await _processImage(file);
            //setState(() {
            //context.read<InquiryCreateViewModel>()
            widget.inquiryViewModel!
                .setImageFile(ImageFile(compressedBytes, _fileName(staffId)));
            //});
          }
        }
      } catch (e) {
        debugPrint("Error selecting image: $e");
        showMessage(Strings.errorSelectingImage);
      } finally {
        //setState(() => isLoading = false);
        widget.inquiryViewModel!.uiState = UiState.success;
        isLoading = widget.inquiryViewModel!.uiState == UiState.loading;
      }
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
