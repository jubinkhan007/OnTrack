import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/widgets/text_view_custom.dart';
import 'package:tmbi/widgets/widgets.dart';

class FileAttachment extends StatelessWidget {
  const FileAttachment({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*_customerView(),
        SizedBox(
          width: Converts.c16,
        ),*/
        _attachmentButton(),
      ],
    );
  }

  Widget _customerView() {
    return Container(
      padding: EdgeInsets.all(Converts.c8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Converts.c20),
        ),
        border: Border.all(
          color: Colors.orange, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_circle,
            color: Colors.black54,
            size: Converts.c20,
          ),
          SizedBox(
            width: Converts.c8,
          ),
          TextViewCustom(
              text: "Md. Akash",
              fontSize: Converts.c16,
              tvColor: Colors.black54,
              isBold: false),
          SizedBox(
            width: Converts.c8,
          ),
          Icon(
            Icons.close,
            color: Colors.black54,
            size: Converts.c20,
          ),
        ],
      ),
    );
  }

  Widget _attachmentButton() {
    return Container(
      width: Converts.c72,
      height: Converts.c72,
      decoration: BoxDecoration(
        //color: Colors.orange,
        borderRadius: BorderRadius.all(
          Radius.circular(Converts.c16),
        ),
        border: Border.all(
          color: Colors.orange, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Icon(
        Icons.add_a_photo,
        size: Converts.c24,
        color: Colors.orange,
      ),
    );
  }
}
