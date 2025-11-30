import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/db/dao/staff_dao_new.dart'; // Your DAO
import '../../db/progress_notifier.dart';
import '../../network/api_service.dart'; // Your ProgressNotifier // Your BU model

class DataSavingProgressScreen extends StatelessWidget {
  static const String routeName = '/data_saving_progress_screen';
  final String staffId; // staffId to be passed to API method

  DataSavingProgressScreen({required this.staffId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Saving Data"),
        ),
        body: Consumer<ProgressNotifier>(
          builder: (context, progressNotifier, _) {
            // Start data saving once the screen is loaded
            if (progressNotifier.progress == 0.0) {
              _startSavingData(context, progressNotifier);
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(value: progressNotifier.progress),
                  SizedBox(height: 20),
                  Text(
                    "Saving Data... ${((progressNotifier.progress) * 100).toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 18),
                  ),
                  if (progressNotifier.progress < 1.0) ...[
                    SizedBox(height: 20),
                    LinearProgressIndicator(value: progressNotifier.progress),
                  ] else ...[
                    SizedBox(height: 20),
                    Text("Data saved successfully!",
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                      child: Text('Finish'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to start saving data
  Future<void> _startSavingData(
      BuildContext context, ProgressNotifier progressNotifier) async {
    try {
      // Call the method to get BU data and save it to DB
      await StaffDaoNew(dio: ApiService(
          "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/")
          .provideDio()).getBUFromApiAndSaveToDb(staffId, progressNotifier);
    } catch (e) {
      // Handle error if needed
      debugPrint("Error: $e");
      // Optionally show error in the UI
    }
  }
}


