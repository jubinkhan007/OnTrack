import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tmbi/config/strings.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../network/ui_state.dart';
import '../viewmodel/viewmodel.dart';

class AttachmentViewScreen extends StatelessWidget {
  static const String routeName = '/attachment_view_screen';
  final String inquiryId;
  final String taskId;
  final PageController _controller = PageController();
  final List<String> _imageUrls = [];

  AttachmentViewScreen(
      {super.key, required this.inquiryId, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final inquiryViewModel =
        Provider.of<InquiryViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inquiryViewModel.getAttachments(inquiryId, taskId);
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.mainColor,
          centerTitle: false,
          title: TextViewCustom(
            text: Strings.attachment,
            fontSize: Converts.c20,
            tvColor: Colors.white,
            isTextAlignCenter: false,
            isBold: true,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            // Customize icon color
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
        ),
        body: Consumer<InquiryViewModel>(
            builder: (context, inquiryViewModel, child) {
          if (inquiryViewModel.uiState == UiState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (inquiryViewModel.uiState == UiState.error) {
            return ErrorContainer(
                message: inquiryViewModel.message != null
                    ? inquiryViewModel.message!
                    : Strings.something_went_wrong);
          }
          // null check for noteResponse and notes
          if (inquiryViewModel.attachmentViewResponse?.isEmpty ?? true) {
            return Center(
              child: ErrorContainer(
                  message: inquiryViewModel.message != null
                      ? inquiryViewModel.message!
                      : Strings.no_data_found),
            );
          } else {
            if (_imageUrls.isNotEmpty) {
              _imageUrls.clear();
            }
            for (var data in inquiryViewModel.attachmentViewResponse!) {
              _imageUrls.add(data.imageUrl ?? "");
            }
          }
          return Column(
            children: [
              /*Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: inquiryViewModel.attachmentViewResponse != null
                      ? inquiryViewModel.attachmentViewResponse!.length
                      : _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      _imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),*/
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: inquiryViewModel.attachmentViewResponse?.length ?? _imageUrls.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: _imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: _imageUrls.length,
                  effect: WormEffect(
                    dotWidth: Converts.c8,
                    dotHeight: Converts.c8,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
