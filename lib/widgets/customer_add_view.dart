import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/widgets/widgets.dart';

import '../config/strings.dart';
import '../models/models.dart';

class CustomerAddView extends StatefulWidget {
  final List<Customer> customers;
  final TextEditingController controller;
  final Function(Customer?) onCustomerSelected;

  const CustomerAddView(
      {super.key,
      required this.onCustomerSelected,
      required this.customers,
      required this.controller});

  @override
  State<CustomerAddView> createState() => _CustomerAddViewState();
}

class _CustomerAddViewState extends State<CustomerAddView> {
  bool _isCustomerViewVisible = false;
  bool _isOtherCustomerViewVisible = false;
  Customer? customer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _isCustomerViewVisible
            ? _isOtherCustomerViewVisible
                ? SizedBox(
                    width: Converts.c200,
                    child: TextFieldInquiry(
                        fontSize: Converts.c16,
                        fontColor: Palette.normalTv,
                        hintColor: Palette.grayColor,
                        hint: Strings.customer_name,
                        hasBorder: true,
                        controller: widget.controller),
                  )
                : _customerView()
            : const SizedBox.shrink(),
        SizedBox(
          width: Converts.c16,
        ),
        _addButton(),
      ],
    );
  }

  Widget _customerView() {
    return Container(
      padding: EdgeInsets.all(Converts.c8),
      decoration: BoxDecoration(
        color: Palette.tabColor.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(Converts.c20),
        ),
        border: Border.all(
          color: Palette.tabColor, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_circle,
            color: Palette.semiTv,
            size: Converts.c20,
          ),
          SizedBox(
            width: Converts.c8,
          ),
          TextViewCustom(
              text: customer != null
                  ? customer!.name != null
                      ? customer!.name!
                      : ""
                  : "",
              fontSize: Converts.c16,
              tvColor: Palette.semiTv,
              isBold: true),
          SizedBox(
            width: Converts.c8,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                customer = null;
                _isCustomerViewVisible = false;
              });
              widget.onCustomerSelected(null);
            },
            child: Padding(
              padding: EdgeInsets.all(Converts.c8),
              child: Icon(
                Icons.close,
                color: Palette.semiTv,
                size: Converts.c20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () {
        _showCustomerDialog(context, widget.customers);
        //onTap();
      },
      child: Container(
        width: Converts.c48,
        height: Converts.c48,
        decoration: BoxDecoration(
          color: Palette.mainColor,
          borderRadius: BorderRadius.all(
            Radius.circular(Converts.c24),
          ),
          border: Border.all(
            color: Palette.mainColor, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Icon(
          Icons.add,
          size: Converts.c24,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showCustomerDialog(BuildContext context, List<Customer> customers) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: TextViewCustom(
                text: Strings.select_customer,
                fontSize: Converts.c16,
                tvColor: Palette.normalTv,
                isTextAlignCenter: false,
                isRubik: false,
                isBold: true),
            content: CustomerSearchDialog(
                customers: customers,
                onCustomerSelected: (customer) {
                  if (customer != null) {
                    setState(() {
                      this.customer = customer;
                      _isCustomerViewVisible = true;
                      if (customer.id == "0") {
                        _isOtherCustomerViewVisible = true;
                      } else {
                        _isOtherCustomerViewVisible = false;
                      }
                    });
                  }
                  widget.onCustomerSelected(customer);
                  debugPrint("CUSTOMER_ID# ${customer.id}");
                  Navigator.of(context).pop();
                }),
          );
        });
  }
}
