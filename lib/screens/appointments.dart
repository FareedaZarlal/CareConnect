import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'booking.dart';
import 'explore.dart';

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});
  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  ApptStatus tab = ApptStatus.upcoming;

  void _details(Appointment a) => showAppSheet(
    context,
    title: 'Appointment details',
    child: Column(
      children: [
        SummaryRow(Icons.calendar_today_outlined, 'Date', prettyDate(a.date)),
        SummaryRow(Icons.access_time, 'Time', a.time),
        SummaryRow(Icons.person_outline, 'Patient', a.patient),
        if (a.reason.isNotEmpty)
          SummaryRow(Icons.edit_outlined, 'Reason for visit', a.reason),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: C.tint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Appointment ID', style: dm(11.5)),
              Text(a.id, style: dm(11.5, w: FontWeight.w700)),
            ],
          ),
        ),
      ],
    ),
  );

  void _confirmCancel(Appointment a) => showAppSheet(
    context,
    title: 'Cancel appointment?',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'This time will become available to other patients. The appointment will remain in your history.',
          style: dm(13, color: C.muted, h: 1.55),
        ),
        const SizedBox(height: 21),
        Row(
          children: [
            Expanded(
              child: Btn(
                'Keep appointment',
                kind: BtnKind.outline,
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Btn(
                'Yes, cancel',
                kind: BtnKind.danger,
                onTap: () {
                  context.read<AppState>().cancel(a);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final items = s.appointments.where((a) => a.status == tab).toList();
    final statusColor = {
      ApptStatus.upcoming: (C.success, const Color(0xFFE8F0EB)),
      ApptStatus.completed: (C.muted, const Color(0xFFECEFED)),
      ApptStatus.cancelled: (C.error, const Color(0xFFF7E9E9)),
    };

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          hpad(const ScreenHeader('My appointments')),
          hpad(
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: C.line)),
              ),
              child: Row(
                children: [
                  for (final x in ApptStatus.values)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => tab = x),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: tab == x ? C.forest : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${x.name[0].toUpperCase()}${x.name.substring(1)}',
                                style: dm(
                                  12.5,
                                  w: FontWeight.w600,
                                  color: tab == x ? C.forest : C.muted,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9ECE8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${s.appointments.where((a) => a.status == x).length}',
                                  style: dm(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 17),
          if (items.isEmpty)
            CenterState(
              icon: Icons.calendar_today_outlined,
              title: 'No ${tab.name} appointments',
              body:
                  tab == ApptStatus.upcoming
                      ? 'When you book a visit, it will appear here.'
                      : 'Your ${tab.name} visits will remain here for reference.',
            )
          else
            for (final a in items)
              hpad(
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: cardBox(),
                  child: Builder(
                    builder: (context) {
                      final d = doctorById(a.doctorId);
                      final (fg, bg) = statusColor[a.status]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${a.status.name[0].toUpperCase()}${a.status.name.substring(1)}',
                                  style: dm(10, w: FontWeight.w700, color: fg),
                                ),
                              ),
                              Text(
                                a.id,
                                style: dm(
                                  10,
                                  color: const Color(0xFF9FA5A1),
                                  ls: .5,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => openDoctor(context, d),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: Row(
                                children: [
                                  NetImage(d.image, w: 51, h: 51, r: 10),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d.name,
                                          style: dm(13.5, w: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          d.specialty,
                                          style: dm(11, color: C.muted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: C.muted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 18,
                                        color: C.forest,
                                      ),
                                      const SizedBox(width: 7),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Date',
                                            style: dm(9, color: C.muted),
                                          ),
                                          Text(
                                            prettyDate(a.date),
                                            style: dm(11, w: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: const Color(0xFFDADDD8),
                                  margin: const EdgeInsets.only(right: 12),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: C.forest,
                                      ),
                                      const SizedBox(width: 7),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Time',
                                            style: dm(9, color: C.muted),
                                          ),
                                          Text(
                                            a.time,
                                            style: dm(11, w: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 11),
                          Container(height: 1, color: const Color(0xFFEDF0EC)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => _details(a),
                                child: Text(
                                  'View details',
                                  style: dm(
                                    12,
                                    w: FontWeight.w700,
                                    color: C.forest,
                                  ),
                                ),
                              ),
                              if (a.status == ApptStatus.upcoming) ...[
                                TextButton(
                                  onPressed:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BookingScreen(
                                                doctor: d,
                                                initial: a,
                                              ),
                                        ),
                                      ),
                                  child: Text(
                                    'Reschedule',
                                    style: dm(
                                      12,
                                      w: FontWeight.w700,
                                      color: C.forest,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _confirmCancel(a),
                                  child: Text(
                                    'Cancel',
                                    style: dm(
                                      12,
                                      w: FontWeight.w700,
                                      color: C.error,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
