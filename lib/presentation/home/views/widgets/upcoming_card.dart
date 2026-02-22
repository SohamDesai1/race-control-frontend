// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:frontend/core/services/notification_service.dart';
import 'package:frontend/utils/injection.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class UpcomingCard extends StatefulWidget {
  final DateTime date;
  final String raceName;
  final String location;
  final VoidCallback? onTap;

  const UpcomingCard({
    super.key,
    required this.date,
    required this.raceName,
    required this.location,
    this.onTap,
  });

  @override
  State<UpcomingCard> createState() => _UpcomingCardState();
}

class _UpcomingCardState extends State<UpcomingCard> {
  final NotificationService _notificationService = getIt<NotificationService>();
  bool _hasReminder = false;

  @override
  void initState() {
    super.initState();
    _checkReminderStatus();
  }

  Future<void> _checkReminderStatus() async {
    final pending = await _notificationService.getPendingReminders();
    final hasReminder = pending.any(
      (n) => n.id == widget.date.millisecondsSinceEpoch ~/ 1000,
    );
    if (mounted) {
      setState(() => _hasReminder = hasReminder);
    }
  }

  Future<void> _toggleReminder() async {
    final granted = await _notificationService.requestPermissions();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission denied')),
      );
      return;
    }

    final id = widget.date.millisecondsSinceEpoch ~/ 1000;

    if (_hasReminder) {
      await _notificationService.cancelReminder(id);
      if (mounted) {
        setState(() => _hasReminder = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder cancelled for ${widget.raceName}')),
        );
      }
    } else {
      await _notificationService.scheduleRaceReminder(
        id: id,
        raceName: widget.raceName,
        raceTime: widget.date,
        minutesBefore: 30,
      );
      if (mounted) {
        setState(() => _hasReminder = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder set for ${widget.raceName}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = RaceUtils.calcStatus(widget.date) == "Completed";

    return Container(
      height: 16.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 16, 16),
        border: Border.all(color: Colors.grey.shade900),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 35, 35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  DateFormat('dd MMM').format(widget.date),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 6.1.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.raceName,
                    style: TextStyle(
                      fontSize: 4.2.w,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 4.w,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          widget.location,
                          style: TextStyle(fontSize: 4.w, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 30, 0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Race Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!isCompleted) ...[
                        SizedBox(width: 2.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: _toggleReminder,
                            child: Container(
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: _hasReminder
                                    ? const Color.fromARGB(255, 0, 150, 0)
                                    : const Color.fromARGB(255, 35, 35, 35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  _hasReminder
                                      ? "Reminder Set"
                                      : "Set Reminder",
                                  style: TextStyle(
                                    color: _hasReminder
                                        ? Colors.white
                                        : Colors.white60,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
