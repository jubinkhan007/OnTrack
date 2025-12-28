import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/viewmodel/new_task/new_task_dashboard_viewmodel.dart';

import '../../config/converts.dart';

class BsAssigns extends StatelessWidget {
  const BsAssigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskDashboardViewmodel>(
        builder: (context, provider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // dialog background
              borderRadius: BorderRadius.circular(20), // dialog round
            ),
            child: Column(
              children: [
                _handle(),
                const SizedBox(height: 8),
                Text(
                  'Assignee',
                  style: TextStyle(
                    fontSize: Converts.c16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: provider.search,
                    controller: provider.searchTextEdit,
                    decoration: InputDecoration(
                      hintText: 'Search name',
                      hintStyle: const TextStyle(color: Colors.black38),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.black38),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        // search bar round
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // selected staffs
                if (provider.selectedStaffs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Assignee (only one member can be added)',
                          style: TextStyle(
                              fontSize: Converts.c16 - 2,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),

                Wrap(
                  spacing: 2,
                  children: provider.selectedStaffs.map((customer) {
                    return Chip(
                      label: Text(
                        customer.userName,
                        style: TextStyle(
                            fontSize: Converts.c16 - 2,
                            fontWeight: FontWeight.bold),
                      ),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => provider.remove(customer),
                    );
                  }).toList(),
                ),

                if (provider.selectedStaffs.isNotEmpty) const Divider(),

                Expanded(
                  child: ListView.builder(
                    itemCount: provider.availableStaffs.length,
                    itemBuilder: (_, index) {
                      final staff = provider.availableStaffs[index];
                      return ListTile(
                        title: Text(
                          staff.userName,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Converts.c16 - 2),
                        ),
                        onTap: () {
                          if (provider.selectedStaffs.isEmpty) {
                            provider.add(staff);
                          }
                          provider.search('');
                          provider.searchTextEdit.text = '';
                          //Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _handle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
