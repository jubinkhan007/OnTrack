import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';
import '../models/models.dart';

class CustomerSearchDialog extends StatefulWidget {
  final List<Customer> customers;
  final Function(Customer?) onCustomerSelected;
  String hintName;

  CustomerSearchDialog(
      {super.key,
      required this.customers,
      required this.onCustomerSelected,
      this.hintName = Strings.search_customer});

  @override
  State<CustomerSearchDialog> createState() => _CustomerSearchDialogState();
}

class _CustomerSearchDialogState extends State<CustomerSearchDialog> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = widget.customers
        .where((customer) => customer.name!.toLowerCase().contains(
              query.toLowerCase(),
            ))
        .toList();

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              //labelText: Strings.search_customer,
              labelText: widget.hintName,
              labelStyle: TextStyle(fontSize: Converts.c16),
              prefixIcon: const Icon(
                Icons.search,
              ), // Add a search icon
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
          SizedBox(height: Converts.c16),
          SizedBox(
            height: Converts.c200,
            child: ListView.builder(
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onCustomerSelected(filteredCustomers[index]);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.account_circle,
                                size: Converts.c20,
                                color: Palette.navyBlueColor),
                            SizedBox(
                              width: Converts.c8,
                            ),
                            Expanded(
                              child: TextViewCustom(
                                  //text: _getNameWithDesignation(filteredCustomers[index].name!),
                                  text: filteredCustomers[index].name!,
                                  //text: "Md. Akash Ahmed (Sub Assistant Manager, Export-Desk)",
                                  fontSize: Converts.c16,
                                  tvColor: Palette.navyBlueColor,
                                  isTextAlignCenter: false,
                                  isBold: false),
                            ),
                            filteredCustomers[index].isVerified != null
                                ? filteredCustomers[index].isVerified!
                                    ? Icon(Icons.verified_user,
                                        size: Converts.c20,
                                        color: Palette.iconColor)
                                    : const SizedBox.shrink()
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(
                          thickness: 0.5,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  /*String _getNameWithDesignation(String data) {
    try {
      var values = data.split("#");
      return "${values[0]}\n${values[1]}\n${values[2]}";
    } catch (e) {
      return data;
    }
  }*/
}

