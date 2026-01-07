import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday % 7;

    List<DateTime> days = [];
    
    final previousMonthLastDay = DateTime(month.year, month.month, 0);
    for (int i = firstWeekday; i > 0; i--) {
      days.add(previousMonthLastDay.subtract(Duration(days: i - 1)));
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(month.year, month.month + 1, i));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_displayedMonth);
    final dayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sat', 'Su'];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: Icon(Icons.chevron_left, size: 28.h),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_displayedMonth),
                  style: TextStyle(
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.w600,
                    color: appTheme.gray80001,
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: Icon(Icons.chevron_right, size: 28.h),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 8.h,
                childAspectRatio: 1,
              ),
              itemCount: days.length + 7,
              itemBuilder: (context, index) {
                if (index < 7) {
                  return Center(
                    child: Text(
                      dayLabels[index],
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontWeight: FontWeight.w600,
                        color: appTheme.gray80001,
                      ),
                    ),
                  );
                }

                final day = days[index - 7];
                final isCurrentMonth = day.month == _displayedMonth.month;
                final isSelected = day.year == _selectedDate.year &&
                    day.month == _selectedDate.month &&
                    day.day == _selectedDate.day;
                final isDisabled = day.isBefore(widget.firstDate) || 
                    day.isAfter(widget.lastDate);

                return GestureDetector(
                  onTap: (isCurrentMonth && !isDisabled)
                      ? () {
                          setState(() => _selectedDate = day);
                          Navigator.pop(context, day);
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? appTheme.deepPurple600
                          : isCurrentMonth && !isDisabled
                              ? appTheme.gray100
                              : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          fontSize: 14.fSize,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : isDisabled
                                  ? appTheme.gray400
                                  : isCurrentMonth
                                      ? appTheme.gray80001
                                      : appTheme.gray400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
