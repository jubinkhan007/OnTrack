import 'package:flutter/material.dart';

import '../../config/converts.dart';
import '../../config/enum.dart';
import '../../config/strings.dart';
import '../../config/app_theme.dart';

class StatusCards extends StatelessWidget {
  final String pending;
  final String overdue;
  final String completed;
  final Function(TaskStatusFlag tsf) onFinalTap;

  const StatusCards({
    super.key,
    required this.pending,
    required this.overdue,
    required this.completed,
    required this.onFinalTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Converts.c8, top: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _statusCard(
              context: context,
              label: Strings.pending,
              value: pending.toString(),
              icon: Icons.hourglass_bottom_rounded,
              base: AppColors.warning,
              onStatusTap: () => onFinalTap(TaskStatusFlag.pending),
            ),
            SizedBox(width: Converts.c8),
            _statusCard(
              context: context,
              label: Strings.overdue1,
              value: overdue.toString(),
              icon: Icons.error_outline_rounded,
              base: AppColors.danger,
              onStatusTap: () => onFinalTap(TaskStatusFlag.overdue),
            ),
            SizedBox(width: Converts.c8),
            _statusCard(
              context: context,
              label: Strings.completed,
              value: completed.toString(),
              icon: Icons.check_circle_outline_rounded,
              base: AppColors.success,
              onStatusTap: () => onFinalTap(TaskStatusFlag.completed),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color base,
    required VoidCallback onStatusTap,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onStatusTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: Converts.c128,
        padding: EdgeInsets.all(Converts.c12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppGradients.status(base),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: base.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: base, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Text(
                          value,
                          key: ValueKey<String>(value),
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.trending_up_rounded,
                        size: 16,
                        color: base.withOpacity(0.75),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
