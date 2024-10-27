import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/text_view_custom.dart';

import '../config/strings.dart';
import '../models/models.dart';

class CustomerSearchDialog extends StatefulWidget {
  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;

  const CustomerSearchDialog(
      {super.key, required this.customers, required this.onCustomerSelected});

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: Strings.search_customer,
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.account_circle,
                              size: Converts.c20, color: Palette.navyBlueColor),
                          SizedBox(
                            width: Converts.c8,
                          ),
                          TextViewCustom(
                              text: filteredCustomers[index].name!,
                              fontSize: Converts.c16,
                              tvColor: Palette.navyBlueColor,
                              isBold: false),
                          filteredCustomers[index].isVerified != null
                              ? filteredCustomers[index].isVerified!
                                  ? Icon(Icons.verified_user,
                                      size: Converts.c20,
                                      color: Palette.iconColor)
                                  : const SizedBox.shrink()
                              : const SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: Converts.c16,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
