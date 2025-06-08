import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CupertinoDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateChanged;
  final String placeholder;
  final bool isRequired;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const CupertinoDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
    this.placeholder = 'Select date',
    this.isRequired = false,
    this.minimumDate,
    this.maximumDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.labelColor),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(AppConstants.systemGray4),
            ),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.all(16),
            onPressed: () => _showDatePicker(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                        : placeholder,
                    style: TextStyle(
                      color: selectedDate != null
                          ? const Color(AppConstants.labelColor)
                          : const Color(AppConstants.systemGray),
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedDate != null && !isRequired) ...[
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 24,
                        onPressed: () => onDateChanged(null),
                        child: const Icon(
                          CupertinoIcons.clear_circled,
                          color: Color(AppConstants.systemGray),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(
                      CupertinoIcons.calendar,
                      color: Color(AppConstants.systemGray),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    DateTime initialDate = selectedDate ?? DateTime.now();
    
    // Ensure initial date is within bounds
    if (minimumDate != null && initialDate.isBefore(minimumDate!)) {
      initialDate = minimumDate!;
    }
    if (maximumDate != null && initialDate.isAfter(maximumDate!)) {
      initialDate = maximumDate!;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.white,
        child: Column(
          children: [
            // Header with actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(AppConstants.systemGray5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(AppConstants.systemGray),
                      ),
                    ),
                  ),
                  if (!isRequired)
                    CupertinoButton(
                      onPressed: () {
                        onDateChanged(null);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(AppConstants.systemRed),
                        ),
                      ),
                    ),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(AppConstants.primaryBlue),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Date picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDateTimeChanged: onDateChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CupertinoTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedTime;
  final Function(DateTime?) onTimeChanged;
  final String placeholder;
  final bool isRequired;

  const CupertinoTimePickerField({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeChanged,
    this.placeholder = 'Select time',
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.labelColor),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(AppConstants.systemGray4),
            ),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.all(16),
            onPressed: () => _showTimePicker(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? DateFormat('h:mm a').format(selectedTime!)
                        : placeholder,
                    style: TextStyle(
                      color: selectedTime != null
                          ? const Color(AppConstants.labelColor)
                          : const Color(AppConstants.systemGray),
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedTime != null && !isRequired) ...[
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 24,
                        onPressed: () => onTimeChanged(null),
                        child: const Icon(
                          CupertinoIcons.clear_circled,
                          color: Color(AppConstants.systemGray),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(
                      CupertinoIcons.clock,
                      color: Color(AppConstants.systemGray),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) {
    DateTime initialTime = selectedTime ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.white,
        child: Column(
          children: [
            // Header with actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(AppConstants.systemGray5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(AppConstants.systemGray),
                      ),
                    ),
                  ),
                  if (!isRequired)
                    CupertinoButton(
                      onPressed: () {
                        onTimeChanged(null);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(AppConstants.systemRed),
                        ),
                      ),
                    ),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(AppConstants.primaryBlue),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Time picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialTime,
                onDateTimeChanged: onTimeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 