import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmbi/config/converts.dart';
import 'package:tmbi/config/palette.dart';
import 'package:tmbi/models/new_task/bu_response.dart';
import 'package:tmbi/models/new_task/report_response.dart';
import 'package:tmbi/network/api_service.dart';
import 'package:tmbi/network/ui_state.dart';
import 'package:tmbi/repo/new_task/report_repo.dart';
import 'package:tmbi/viewmodel/new_task/report_viewmodel.dart';
import 'package:tmbi/widgets/error_container.dart';

class ReportScreen extends StatelessWidget {
  static const String routeName = '/report_screen';

  const ReportScreen({super.key});

  static Widget create(String staffId, List<CompInfo> companyList) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewmodel(
        staffId: staffId,
        companyList: companyList,
        reportRepo: ReportRepo(
          dio: ApiService('https://ego.rflgroupbd.com:8077/ords/rpro/kickall/')
              .provideDio(),
        ),
      ),
      child: const ReportScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReportViewmodel>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Reports'),
          backgroundColor: Palette.navyBlueColor,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Department'),
              Tab(text: 'Company'),
              Tab(text: 'User'),
            ],
          ),
        ),
        body: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReportViewmodel vm) {
    if (vm.uiState == UiState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.uiState == UiState.error) {
      return Center(child: ErrorContainer(message: vm.errorMessage));
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Converts.c12),
          child: _FilterBar(vm: vm),
        ),
        Expanded(
          child: TabBarView(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(Converts.c12),
                child: _DeptWiseTable(rows: vm.deptData),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(Converts.c12),
                child: _CompanyWiseTable(rows: vm.companyData),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(Converts.c12),
                child: _UserWiseTable(rows: vm.userData),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Bar
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  final ReportViewmodel vm;

  const _FilterBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    final allOption = ReportFilterOption(id: '0', name: 'All');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Company dropdown
          _buildDropdown<CompInfo>(
            label: 'Company',
            value: vm.companyList.isEmpty
                ? null
                : vm.companyList.firstWhere(
                    (c) => c.compId == vm.selectedCompId,
                    orElse: () => vm.companyList.first,
                  ),
            items: vm.companyList,
            itemLabel: (c) => c.name,
            onChanged: (c) =>
                vm.onFilterChanged(compId: c?.compId ?? '0'),
          ),
          SizedBox(width: Converts.c8),

          // Group dropdown
          _buildFilterDropdown(
            label: 'Group',
            selectedId: vm.selectedGroupId,
            options: vm.filterOptions.groups,
            allOption: allOption,
            onChanged: (id) => vm.onFilterChanged(groupId: id),
          ),
          SizedBox(width: Converts.c8),

          // Department dropdown
          _buildFilterDropdown(
            label: 'Dept',
            selectedId: vm.selectedDeptId,
            options: vm.filterOptions.depts,
            allOption: allOption,
            onChanged: (id) => vm.onFilterChanged(deptId: id),
          ),
          SizedBox(width: Converts.c8),

          // Sub Dept dropdown
          _buildFilterDropdown(
            label: 'Sub Dept',
            selectedId: vm.selectedSubDeptId,
            options: vm.filterOptions.subDepts,
            allOption: allOption,
            onChanged: (id) => vm.onFilterChanged(subDeptId: id),
          ),
          SizedBox(width: Converts.c8),

          // TNA Type dropdown
          _buildFilterDropdown(
            label: 'TNA Type',
            selectedId: vm.selectedTnaTypeId,
            options: vm.filterOptions.tnaTypes,
            allOption: allOption,
            onChanged: (id) => vm.onFilterChanged(tnaTypeId: id),
          ),
          SizedBox(width: Converts.c8),

          // Reset button
          OutlinedButton(
            onPressed: vm.resetFilters,
            style: OutlinedButton.styleFrom(
              foregroundColor: Palette.mainColor,
              side: const BorderSide(color: Palette.mainColor),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(Converts.c8, 4, Converts.c8, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Converts.c8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButton<T>(
            value: value,
            hint: Text('All', style: TextStyle(fontSize: Converts.c12)),
            underline: const SizedBox.shrink(),
            isDense: true,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  style: TextStyle(fontSize: Converts.c12),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String selectedId,
    required List<ReportFilterOption> options,
    required ReportFilterOption allOption,
    required ValueChanged<String> onChanged,
  }) {
    final allItems = [allOption, ...options];
    final currentValue = allItems.firstWhere(
      (o) => o.id == selectedId,
      orElse: () => allOption,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(Converts.c8, 4, Converts.c8, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Converts.c8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButton<ReportFilterOption>(
            value: currentValue,
            underline: const SizedBox.shrink(),
            isDense: true,
            items: allItems.map((opt) {
              return DropdownMenuItem<ReportFilterOption>(
                value: opt,
                child: Text(
                  opt.name.isEmpty ? 'All' : opt.name,
                  style: TextStyle(fontSize: Converts.c12),
                ),
              );
            }).toList(),
            onChanged: (opt) {
              if (opt != null) onChanged(opt.id);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Department Wise Table
// ---------------------------------------------------------------------------

class _DeptWiseTable extends StatelessWidget {
  final List<DeptWiseStatus> rows;

  const _DeptWiseTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(Converts.c16),
          child: const Text('No data', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columnSpacing: Converts.c16,
        columns: _headers(
            ['Department', 'Total', 'This Month', 'On Hand', 'Overdue', 'Success%', 'Fail%']),
        rows: rows.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.deptName,
                style: TextStyle(fontSize: Converts.c12))),
            DataCell(_numCell(r.total)),
            DataCell(_numCell(r.last30Days)),
            DataCell(_badgeCell(r.onHand, Colors.orange[100]!)),
            DataCell(_badgeCell(r.overdue, Colors.red[100]!)),
            DataCell(_percentCell(r.successPercent)),
            DataCell(_numCell(r.delay)),
          ]);
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Company Wise Table
// ---------------------------------------------------------------------------

class _CompanyWiseTable extends StatelessWidget {
  final List<CompanyWiseStatus> rows;

  const _CompanyWiseTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(Converts.c16),
          child: const Text('No data', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columnSpacing: Converts.c16,
        columns: _headers(
            ['Company', 'Total', 'This Month', 'On Hand', 'Overdue', 'Success%', 'Fail%']),
        rows: rows.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.companyName,
                style: TextStyle(fontSize: Converts.c12))),
            DataCell(_numCell(r.total)),
            DataCell(_numCell(r.last30Days)),
            DataCell(_badgeCell(r.onHand, Colors.orange[100]!)),
            DataCell(_badgeCell(r.overdue, Colors.red[100]!)),
            DataCell(_percentCell(r.successPercent)),
            DataCell(_percentCell(r.failPercent)),
          ]);
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// User Wise Table
// ---------------------------------------------------------------------------

class _UserWiseTable extends StatelessWidget {
  final List<UserWiseStatus> rows;

  const _UserWiseTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(Converts.c16),
          child: const Text('No data', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columnSpacing: Converts.c16,
        columns: _headers(
            ['User', 'Total', 'This Month', 'On Hand', 'Overdue', 'Success%', 'Fail%']),
        rows: rows.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.userName,
                style: TextStyle(fontSize: Converts.c12))),
            DataCell(_numCell(r.total)),
            DataCell(_numCell(r.last30Days)),
            DataCell(_badgeCell(r.onHand, Colors.orange[100]!)),
            DataCell(_badgeCell(r.overdue, Colors.red[100]!)),
            DataCell(_percentCell(r.successPercent)),
            DataCell(_numCell(r.delay)),
          ]);
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

List<DataColumn> _headers(List<String> labels) {
  return labels
      .map((l) => DataColumn(
            label: Text(
              l,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Converts.c12,
                color: Palette.navyBlueColor,
              ),
            ),
          ))
      .toList();
}

Widget _numCell(String value) {
  return Text(value, style: TextStyle(fontSize: Converts.c12));
}

Widget _badgeCell(String value, Color color) {
  if (value == '0') return Text('0', style: TextStyle(fontSize: Converts.c12));
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: Converts.c8, vertical: Converts.c8 / 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(Converts.c8),
    ),
    child: Text(value,
        style: TextStyle(fontSize: Converts.c12, fontWeight: FontWeight.bold)),
  );
}

Widget _percentCell(String value) {
  final numeric = double.tryParse(value) ?? 0;
  final color = numeric >= 0 ? Colors.green[700]! : Colors.red[700]!;
  return Text(
    '$value%',
    style: TextStyle(
      fontSize: Converts.c12,
      color: color,
      fontWeight: FontWeight.bold,
    ),
  );
}
