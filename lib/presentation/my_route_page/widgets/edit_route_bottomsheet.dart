import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/saved_route_model.dart';
import '../notifier/my_route_notifier.dart';

class EditRouteBottomsheet extends ConsumerStatefulWidget {
  const EditRouteBottomsheet({super.key, required this.route});

  final SavedRouteModel route;

  @override
  ConsumerState<EditRouteBottomsheet> createState() =>
      _EditRouteBottomsheetState();
}

class _EditRouteBottomsheetState extends ConsumerState<EditRouteBottomsheet> {
  late final TextEditingController _titleController;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.route.routetitle ?? '',
    );
    final existingDeparture = widget.route.departureTime;
    if (existingDeparture != null) {
      _selectedTime = TimeOfDay(
        hour: existingDeparture.hour,
        minute: existingDeparture.minute,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final routeId = widget.route.id ?? '';
    if (routeId.isEmpty) return;

    setState(() => _isSaving = true);

    // Compose the new departure DateTime by anchoring the time to the
    // route's existing date so we don't accidentally shift the day.
    DateTime? nextDeparture;
    if (_selectedTime != null) {
      final base = widget.route.departureTime ?? DateTime.now();
      nextDeparture = DateTime(
        base.year,
        base.month,
        base.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    final ok = await ref.read(myRouteNotifier.notifier).updateScheduledRoute(
          routeId: routeId,
          title: _titleController.text,
          departureTime: nextDeparture,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (ok) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = _selectedTime == null
        ? 'Select time'
        : _selectedTime!.format(context);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 50.h,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D1D1),
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Edit route',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.fSize,
                    color: const Color(0xFF262626),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Route name',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.fSize,
                    color: const Color(0xFF6D6D6D),
                  ),
                ),
                SizedBox(height: 6.h),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'e.g. Work Route',
                    hintStyle: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14.fSize,
                      color: const Color(0xFFB0B0B0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.h,
                      vertical: 12.h,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.h),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14.fSize,
                    color: const Color(0xFF262626),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Departure time',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.fSize,
                    color: const Color(0xFF6D6D6D),
                  ),
                ),
                SizedBox(height: 6.h),
                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(8.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.h,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18.h,
                          color: const Color(0xFF6D6D6D),
                        ),
                        SizedBox(width: 10.h),
                        Expanded(
                          child: Text(
                            timeLabel,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14.fSize,
                              color: _selectedTime == null
                                  ? const Color(0xFFB0B0B0)
                                  : const Color(0xFF262626),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1AD3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save changes',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w600,
                              fontSize: 14.fSize,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
