import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';

class FileAttachment extends StatefulWidget {
  final Function(List<XFile>?) onFileAttached;
  const FileAttachment({super.key, required this.onFileAttached});

  @override
  State<FileAttachment> createState() => _FileAttachmentState();
}

class _FileAttachmentState extends State<FileAttachment> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _imageFiles = [];

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
                        // pass files
                        widget.onFileAttached(_imageFiles);
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
        setState(() {
          _imageFiles.add(image);
          // pass files
          widget.onFileAttached(_imageFiles);
        });
      }
    }
  }

  Future<void> _pickImages() async {
    if (await _checkPermissions(Permission.storage)) {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          _imageFiles.addAll(selectedImages);
          // pass files
          widget.onFileAttached(_imageFiles);
        });
      }
    }
  }

}
