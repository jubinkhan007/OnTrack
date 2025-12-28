import 'package:flutter/material.dart';
import 'package:tmbi/config/converts.dart';

class DropdownType extends StatelessWidget {
  final DropdownOption selected;
  final VoidCallback onTap;

  const DropdownType({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            //border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                selected.icon,
                size: Converts.c16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 8),
              Text(
                selected.label,
                style: TextStyle(color: Colors.grey.shade500),
              ),
              //const Spacer(),
              //const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  static Future<DropdownOption?> showOptionBottomSheet({
    required BuildContext context,
    required List<DropdownOption> options,
  }) {
    return showModalBottomSheet<DropdownOption>(
      context: context,
      backgroundColor: Colors.white,
      //isDismissible: false,
      //enableDrag: false,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //_sheetHeader(context),
              const SizedBox(
                height: 16,
              ),
              ...options.map((option) {
                return ListTile(
                  leading: Icon(
                    option.icon,
                    color: option.color,
                    size: Converts.c16,
                  ),
                  title: Text(option.label,
                      style: TextStyle(fontSize: Converts.c16)),
                  onTap: () {
                    Navigator.pop(context, option);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  static Widget _sheetHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Spacer(),
          const Text(
            'Select',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class DropdownOption {
  final int id;
  final IconData icon;
  final Color color;
  final String label;

  DropdownOption(
      {required this.id, this.color = Colors.black87, required this.icon, required this.label});
}
