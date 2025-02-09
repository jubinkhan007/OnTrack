import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/pair.dart';
import 'package:tmbi/viewmodel/settings_viewmodel.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../widgets/text_view_custom.dart';

class SettingScreen extends StatelessWidget {
  static const String routeName = '/setting_screen';

  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainColor,
        centerTitle: false,
        title: TextViewCustom(
          text: Strings.setting,
          fontSize: Converts.c20,
          tvColor: Colors.white,
          isTextAlignCenter: false,
          isRubik: false,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SettingsViewModel>(
            builder: (context, settingsViewModel, child) {
          return Column(
            children: [
              _buildToggleRow(
                  Icons.task, Strings.first_task_entry, settingsViewModel,
                  (value) {
                settingsViewModel.toggleFirstTaskEntryFlag();
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildToggleRow(IconData icon, String title,
      SettingsViewModel settingsViewModel, Function(bool) onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: Converts.c32,
          width: Converts.c32,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(8)),
          child: Icon(
            icon,
            color: Colors.white,
            size: Converts.c24,
          ),
        ),
        SizedBox(width: Converts.c16),
        Expanded(
          child: TextViewCustom(
            //text: Strings.first_task_entry,
            text: title,
            fontSize: Converts.c20,
            tvColor: Palette.normalTv,
            isTextAlignCenter: false,
            isRubik: false,
            isBold: true,
          ),
        ),
        Text(
          settingsViewModel.isFirstTaskEntryToggled ? 'ON' : 'OFF',
          style: TextStyle(
            color: settingsViewModel.isFirstTaskEntryToggled
                ? Colors.green
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: settingsViewModel.isFirstTaskEntryToggled,
          onChanged: (value) {
            onTap(value);
          },
        ),
      ],
    );
  }
}

class Setting {
  final int id;
  final String name;
  bool isSynced;
  bool isChecked;
  final IconData iconData;
  final Function(bool) onCheckedChanged;
  final Function(Pair<bool, String>) onTap;

  Setting({
    required this.id,
    required this.name,
    required this.iconData,
    this.isSynced = false,
    this.isChecked = false,
    required this.onCheckedChanged,
    required this.onTap,
  });
}
