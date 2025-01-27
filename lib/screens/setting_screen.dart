import 'package:flutter/material.dart';
import 'package:tmbi/config/sp_helper.dart';

import '../config/converts.dart';
import '../config/palette.dart';
import '../config/strings.dart';
import '../widgets/text_view_custom.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = '/setting_screen';

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
    _loadToggleFlag();
  }

  void _loadToggleFlag() async {
    bool flag = await SPHelper().getFirstTaskEntryFlag();
    setState(() {
      _isToggled = flag;
    });
  }

  void _savePreferences() async {
    SPHelper().saveFirstTaskEntryFlag(_isToggled);
  }

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Converts.c32,
                  width: Converts.c32,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.task,
                    color: Colors.white,
                    size: Converts.c24,
                  ),
                ), // Your icon
                SizedBox(width: Converts.c16),
                Expanded(
                  child: TextViewCustom(
                    text: Strings.first_task_entry,
                    fontSize: Converts.c20,
                    tvColor: Palette.normalTv,
                    isTextAlignCenter: false,
                    isRubik: false,
                    isBold: true,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isToggled = !_isToggled;
                      _savePreferences(); // Save the toggle state when tapped
                    });
                  },
                  child: Text(
                    _isToggled ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: _isToggled ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _isToggled,
                  onChanged: (value) {
                    setState(() {
                      _isToggled = value;
                      _savePreferences(); // Save the toggle state when changed
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
