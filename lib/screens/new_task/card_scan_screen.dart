import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/converts.dart';
import '../../models/new_task/visiting_card_data.dart';
import '../../viewmodel/new_task/camera_provider.dart';

class CardScanScreen extends StatelessWidget {
  final String staffId;
  static const String routeName = '/card_scan_screen';

  const CardScanScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraProvider()..initCamera(),
      child: const _CameraView(),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView();

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (_, provider, __) {
        if (!provider.isReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: CustomScrollView(slivers: [
            // app bar
            SliverAppBar(
              title: Text(
                "Scan Cards",
                style: TextStyle(fontSize: Converts.c16),
              ),
              centerTitle: true,
              backgroundColor: Colors.redAccent,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 16),
                    // camera preview
                    Container(
                      height: 360,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.black12,
                      ),
                      child: Stack(
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 8,
                              sigmaY: 8,
                            ),
                            child: Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 64,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                          // camera preview
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: provider.boxWidth,
                                height: provider.boxHeight,
                                child: provider.capturedImage == null
                                    ? FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: provider.controller!.value
                                              .previewSize!.height,
                                          height: provider.controller!.value
                                              .previewSize!.width,
                                          child: CameraPreview(
                                              provider.controller!),
                                        ),
                                      )
                                    : Image.file(
                                        File(provider.capturedImage!.path),
                                        width: provider.boxWidth,
                                        height: provider.boxHeight,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          // frame
                          Center(
                            child: Container(
                              width: provider.boxWidth,
                              height: provider.boxHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF2D8CFF),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          // flash icon
                          const Positioned(
                            top: 16,
                            right: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.black45,
                              child: Icon(
                                Icons.flash_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )/*CameraPreview(
                          provider.controller!)*/,
                    ),
                    const SizedBox(height: 24),
                    // if image uploading
                    provider.isUploading
                        ? Column(
                            children: [
                              const CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Extracting contact info...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Converts.c16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'This may take a few seconds',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Converts.c16 - 2,
                                  color: Colors.black38,
                                ),
                              ),
                              const SizedBox(height: 24),
                              LinearProgressIndicator(
                                value: provider.uploadProgress,
                                minHeight: 8,
                                color: Colors.blueAccent,
                                backgroundColor: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(provider.uploadProgress * 100).toInt()}%',
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              // instruction
                              Text(
                                'Align the business card within the frame\n'
                                'to scan details automatically.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Converts.c16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 28),
                              // capture Button
                              SizedBox(
                                height: Converts.c56,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    provider.captureImage(context);
                                  },
                                  icon: const Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Capture Image',
                                    style: TextStyle(
                                        fontSize: Converts.c16,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D8CFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // retake Button
                              SizedBox(
                                height: Converts.c56,
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    provider.retake();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: Text(
                                    'Retake',
                                    style: TextStyle(fontSize: Converts.c16),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black87,
                                    side:
                                        const BorderSide(color: Colors.black12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              //select from Gallery
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.image_outlined,
                                    color: Colors.black54,
                                  ),
                                  label: Text(
                                    'Select from Gallery',
                                    style: TextStyle(
                                        fontSize: Converts.c16 - 2,
                                        color: Colors.black54),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}


class ReviewDetailsFullScreen extends StatelessWidget {
  //final CameraProvider cameraProvider;
  final VisitingCardData cardData;
  final File? file;
  final double width;
  final double height;

  const ReviewDetailsFullScreen({
    Key? key,
    //required this.cameraProvider,
    required this.cardData,
    required this.file, required this.width, required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
    TextEditingController(text: cardData.name);
    final TextEditingController titleController =
    TextEditingController(text: cardData.title);
    final TextEditingController companyController =
    TextEditingController(text: cardData.company);
    final TextEditingController emailController =
    TextEditingController(text: cardData.email);
    final TextEditingController phoneController =
    TextEditingController(text: cardData.phone);
    final TextEditingController mobileController =
    TextEditingController(text: cardData.mobile);
    final TextEditingController websiteController =
    TextEditingController(text: cardData.website);
    final TextEditingController addressController =
    TextEditingController(text: cardData.extraText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Details'),
        actions: [
          TextButton(
            onPressed: () {
              // Save edited details back to cameraProvider or your backend logic
              // Example:
              // cameraProvider.saveCardDetails(...);

              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image preview + retake button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: file == null
                        ? SizedBox(
                      height: height,
                      width: width,
                      child: const Center(child: Text("No Image")),
                    )
                        : Image.file(
                      file!,
                      width: height,
                      height: width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: const Text('Retake Scan'),
                      onPressed: () {
                        Navigator.pop(context); // close dialog to retake
                      },
                      style: ElevatedButton.styleFrom(
                        //primary: Colors.black.withOpacity(0.5),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),

              _buildTextField('Full Name', nameController),
              _buildTextField('Job Title', titleController),
              _buildTextField('Company', companyController),
              _buildTextField('Phone Number', phoneController, keyboardType: TextInputType.phone),
              _buildTextField('Mobile', mobileController, keyboardType: TextInputType.phone),
              _buildTextField('Email Address', emailController, keyboardType: TextInputType.emailAddress),
              _buildTextField('Website', websiteController, keyboardType: TextInputType.url),
              _buildTextField('Address', addressController, maxLines: 3),

              const SizedBox(height: 20),

              const Text(
                'Please review the details carefully. Some fields might have been auto-corrected by our scanning engine.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
