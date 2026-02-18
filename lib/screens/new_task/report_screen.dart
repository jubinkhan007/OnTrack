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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Palette.navyBlueColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, ReportViewmodel vm) {
    if (vm.uiState == UiState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.uiState == UiState.error) {
      return Center(child: ErrorContainer(message: vm.errorMessage));
    }

    return RefreshIndicator(
      onRefresh: () => vm.loadReport(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(Converts.c12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterBar(vm: vm),
            SizedBox(height: Converts.c12),
            _sectionLabel('Task Summary'),
            SizedBox(height: Converts.c8),
            _SummaryCards(summary: vm.reportData.taskSummary, showRunning: false),
            SizedBox(height: Converts.c12),
            _sectionLabel('TNA Summary'),
            SizedBox(height: Converts.c8),
            _SummaryCards(summary: vm.reportData.tnaSummary, showRunning: true),
            SizedBox(height: Converts.c16),
            _sectionLabel('Department Wise Status'),
            SizedBox(height: Converts.c8),
            _DeptWiseTable(rows: vm.reportData.deptWise),
            SizedBox(height: Converts.c16),
            _sectionLabel('Company Wise Status'),
            SizedBox(height: Converts.c8),
            _CompanyWiseTable(rows: vm.reportData.companyWise),
            SizedBox(height: Converts.c16),
            _sectionLabel('User Wise Status'),
            SizedBox(height: Converts.c8),
            _UserWiseTable(rows: vm.reportData.userWise),
            SizedBox(height: Converts.c32),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Converts.c16,
        fontWeight: FontWeight.bold,
        color: Palette.navyBlueColor,
      ),
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
      padding: EdgeInsets.symmetric(horizontal: Converts.c8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Converts.c8),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: Text(label, style: TextStyle(fontSize: Converts.c12)),
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
      padding: EdgeInsets.symmetric(horizontal: Converts.c8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Converts.c8),
      ),
      child: DropdownButton<ReportFilterOption>(
        value: currentValue,
        hint: Text(label, style: TextStyle(fontSize: Converts.c12)),
        underline: const SizedBox.shrink(),
        isDense: true,
        items: allItems.map((opt) {
          return DropdownMenuItem<ReportFilterOption>(
            value: opt,
            child: Text(
              opt.name.isEmpty ? label : opt.name,
              style: TextStyle(fontSize: Converts.c12),
            ),
          );
        }).toList(),
        onChanged: (opt) {
          if (opt != null) onChanged(opt.id);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary Cards
// ---------------------------------------------------------------------------

class _SummaryCards extends StatelessWidget {
  final ReportSummary summary;
  final bool showRunning;

  const _SummaryCards({required this.summary, required this.showRunning});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _card('Last 30 Days', summary.last30Days, Colors.green[100]!),
          SizedBox(width: Converts.c8),
          _card('Overdue', summary.overdue, Colors.red[100]!),
          SizedBox(width: Converts.c8),
          _card('On Queue', summary.onQueue, Colors.orange[100]!),
          SizedBox(width: Converts.c8),
          _card('Upcoming', summary.upcoming, Colors.blue[100]!),
          SizedBox(width: Converts.c8),
          _card('Completed', summary.completed, Colors.green[200]!),
          if (showRunning) ...[
            SizedBox(width: Converts.c8),
            _card('Running', summary.running, Colors.grey[200]!),
          ],
        ],
      ),
    );
  }

  Widget _card(String label, String value, Color color) {
    return Container(
      width: Converts.c112,
      padding: EdgeInsets.all(Converts.c8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Converts.c12),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: Converts.c12, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Converts.c20,
              fontWeight: FontWeight.bold,
            ),
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
          child: Text('No data', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columnSpacing: Converts.c16,
        columns: _headers(
            ['Department', 'Total', 'Last 30D', 'On Hand', 'Overdue', 'Success%', 'Delay']),
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
          child: Text('No data', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columnSpacing: Converts.c16,
        columns: _headers(
            ['Company', 'Total', 'Last 30D', 'On Hand', 'Overdue', 'Success%']),
        rows: rows.map((r) {
          return DataRow(cells: [
            DataCell(Text(r.companyName,
                style: TextStyle(fontSize: Converts.c12))),
            DataCell(_numCell(r.total)),
            DataCell(_numCell(r.last30Days)),
            DataCell(_badgeCell(r.onHand, Colors.orange[100]!)),
            DataCell(_badgeCell(r.overdue, Colors.red[100]!)),
            DataCell(_percentCell(r.successPercent)),
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
          child: Text('No data', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columnSpacing: Converts.c16,
        columns: _headers(
            ['User', 'Total', 'Last 30D', 'On Hand', 'Overdue', 'Success%', 'Delay']),
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
