import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.doctor, this.initial});
  final Doctor doctor;
  final Appointment? initial;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late int step;
  late final List<DateTime> dates;
  late String date;
  String time = '';
  late final TextEditingController patient, phone, reason;
  String error = '';

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    final user = context.read<AppState>().user!;
    step = init != null ? 1 : 0;
    final now = DateTime.now();
    dates = List.generate(9, (i) => now.add(Duration(days: i + 1)));
    date = init?.date ?? dateKey(dates.first);
    time = init?.time ?? '';
    patient = TextEditingController(text: init?.patient ?? user.name);
    phone = TextEditingController(text: init?.phone ?? user.phone);
    reason = TextEditingController(text: init?.reason ?? '');
  }

  @override
  void dispose() {
    patient.dispose();
    phone.dispose();
    reason.dispose();
    super.dispose();
  }

  bool occupied(String slot, List<Appointment> all) => all.any(
    (a) =>
        a.doctorId == widget.doctor.id &&
        a.date == date &&
        a.time == slot &&
        a.status == ApptStatus.upcoming &&
        a.id != widget.initial?.id,
  );

  void next() {
    setState(() => error = '');
    if (step == 1 && time.isEmpty)
      return setState(() => error = 'Choose an available time to continue.');
    if (step == 2 &&
        (patient.text.trim().isEmpty ||
            phone.text.replaceAll(RegExp(r'\D'), '').length < 10)) {
      return setState(
        () => error = 'Enter a patient name and valid phone number.',
      );
    }
    if (step < 3) return setState(() => step++);
    final failure = context.read<AppState>().confirmBooking(
      doctor: widget.doctor,
      date: date,
      time: time,
      patient: patient.text.trim(),
      phone: phone.text.trim(),
      reason: reason.text.trim(),
      rescheduling: widget.initial,
    );
    if (failure != null) return setState(() => error = failure);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SuccessScreen()),
    );
  }

  Widget _head(String eyebrow, String title, String sub) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 27),
      Eyebrow(eyebrow),
      const SizedBox(height: 7),
      Text(title, style: manrope(23)),
      const SizedBox(height: 5),
      Text(sub, style: dm(12.5, color: C.muted)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    final all = context.watch<AppState>().appointments;
    const labels = ['Select date', 'Select time', 'Patient details', 'Confirm'];
    final editing = widget.initial != null;

    Widget body;
    if (step == 0) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'CHOOSE A DAY',
            'Select appointment date',
            'Appointments are shown in your local time.',
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final x = dates[i];
                final on = date == dateKey(x);
                final sub = on ? const Color(0xFFC7D4CE) : C.muted;
                return GestureDetector(
                  onTap:
                      () => setState(() {
                        date = dateKey(x);
                        time = '';
                      }),
                  child: Container(
                    width: 61,
                    decoration: BoxDecoration(
                      color: on ? C.forest : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: on ? C.forest : C.line),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(weekdayShort(x), style: dm(10.5, color: sub)),
                        Text(
                          '${x.day}',
                          style: manrope(
                            22,
                            w: FontWeight.w700,
                            color: on ? Colors.white : C.ink,
                          ),
                        ),
                        Text(monthShort(x), style: dm(10.5, color: sub)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 17),
            padding: const EdgeInsets.all(13),
            decoration: cardBox(r: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                  color: C.forest,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prettyDate(date), style: dm(12.5, w: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      '7 appointment times available',
                      style: dm(10.5, color: C.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else if (step == 1) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'AVAILABLE TIMES',
            'Choose a time',
            '${prettyDate(date)} · 30 minute consultation',
          ),
          const SizedBox(height: 23),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: slots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 9,
              crossAxisSpacing: 9,
              mainAxisExtent: 52,
            ),
            itemBuilder: (_, i) {
              final slot = slots[i];
              final disabled = occupied(slot, all) || i == 3;
              final on = time == slot;
              return GestureDetector(
                onTap: disabled ? null : () => setState(() => time = slot),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        disabled
                            ? const Color(0xFFEFEFEC)
                            : (on ? const Color(0xFFE8EFEA) : Colors.white),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: on ? C.forest : C.line,
                      width: on ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        slot,
                        style: dm(
                          13,
                          w: FontWeight.w600,
                          color:
                              disabled
                                  ? const Color(0xFFA8AFAB)
                                  : (on ? C.forest : C.ink),
                        ).copyWith(
                          decoration:
                              disabled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (disabled)
                        Text(
                          'Unavailable',
                          style: dm(8.5, color: const Color(0xFFA8AFAB)),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else if (step == 2) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'PATIENT INFORMATION',
            'Who is this visit for?',
            'Confirm the details the clinic should use.',
          ),
          const SizedBox(height: 16),
          AppField(
            label: 'Patient name',
            icon: Icons.person_outline,
            controller: patient,
          ),
          const SizedBox(height: 13),
          AppField(
            label: 'Phone number',
            icon: Icons.phone_outlined,
            controller: phone,
            keyboard: TextInputType.phone,
          ),
          const SizedBox(height: 13),
          AppField(
            label: 'Reason for visit',
            optional: true,
            controller: reason,
            maxLines: 4,
            maxLength: 180,
            hint: "Briefly describe what you'd like to discuss",
            onChanged: (_) => setState(() {}),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${reason.text.length}/180',
                style: dm(11, color: C.muted),
              ),
            ),
          ),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(
            'REVIEW & CONFIRM',
            'Your appointment summary',
            'Please review your details before confirming.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: cardBox(),
            child: Column(
              children: [
                SummaryRow(
                  Icons.calendar_today_outlined,
                  'Date',
                  prettyDate(date),
                ),
                SummaryRow(Icons.access_time, 'Time', time),
                SummaryRow(
                  Icons.person_outline,
                  'Patient',
                  patient.text.trim(),
                ),
                SummaryRow(Icons.phone_outlined, 'Contact', phone.text.trim()),
                if (reason.text.trim().isNotEmpty)
                  SummaryRow(Icons.edit_outlined, 'Reason', reason.text.trim()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Consultation fee', style: dm(12)),
                      Text(
                        '\$${d.fee}.00',
                        style: manrope(17, w: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 16,
                color: C.success,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Free cancellation up to 24 hours before your appointment.',
                  style: dm(11.5, color: C.success, h: 1.4),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            hpad(
              ScreenHeader(
                editing ? 'Reschedule' : 'Book appointment',
                onBack: () => Navigator.pop(context),
              ),
            ),
            hpad(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < 4; i++)
                        Expanded(
                          child: Container(
                            height: 3,
                            margin: EdgeInsets.only(right: i < 3 ? 5 : 0),
                            decoration: BoxDecoration(
                              color:
                                  i <= step
                                      ? C.forest
                                      : const Color(0xFFDFE2DE),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${step + 1} of 4 · ${labels[step]}',
                    style: dm(11, color: C.muted),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 67,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: C.tint,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          NetImage(d.image, w: 50, h: 50, r: 9),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.name, style: dm(13, w: FontWeight.w700)),
                                Text(
                                  d.specialty,
                                  style: dm(10.5, color: C.muted),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${d.fee}',
                            style: manrope(14, w: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    body,
                    if (error.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 13),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8EAEA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFF9C4545),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                error,
                                style: dm(11.5, color: const Color(0xFF9C4545)),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: C.line)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  if (step > 0) ...[
                    SizedBox(
                      width: 92,
                      child: Btn(
                        'Back',
                        kind: BtnKind.outline,
                        onTap:
                            () => setState(() {
                              step--;
                              error = '';
                            }),
                      ),
                    ),
                    const SizedBox(width: 9),
                  ],
                  Expanded(
                    child: Btn(
                      step == 3
                          ? (editing
                              ? 'Confirm reschedule'
                              : 'Confirm appointment')
                          : 'Continue',
                      icon: step == 3 ? Icons.check : Icons.arrow_forward,
                      onTap: next,
                    ),
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

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final a = s.lastBooked!;
    final d = doctorById(a.doctorId);
    Widget cell(String l, String v) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: dm(10, color: C.muted)),
        const SizedBox(height: 3),
        Text(v, style: dm(13, w: FontWeight.w700)),
      ],
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 56),
              color: C.forest,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 81,
                      height: 81,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0x33FFFFFF)),
                      ),
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: C.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 21),
                    const Eyebrow('APPOINTMENT CONFIRMED', light: true),
                    const SizedBox(height: 10),
                    Text(
                      'You’re all set.',
                      style: manrope(29, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your appointment has been reserved. We’ll remind you before it’s time.',
                      textAlign: TextAlign.center,
                      style: dm(13, color: const Color(0xFFBDCEC7), h: 1.55),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -32),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: C.ink.withValues(alpha: .08),
                      blurRadius: 35,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        NetImage(d.image, w: 51, h: 51, r: 10),
                        const SizedBox(width: 11),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.name, style: dm(13.5, w: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(d.specialty, style: dm(11, color: C.muted)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 29, color: Color(0xFFDADDD9)),
                    Row(
                      children: [
                        Expanded(child: cell('Date', prettyDate(a.date))),
                        Container(
                          width: 1,
                          height: 34,
                          color: C.line,
                          margin: const EdgeInsets.only(right: 18),
                        ),
                        Expanded(child: cell('Time', a.time)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: C.tint,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Appointment ID', style: dm(10, color: C.muted)),
                          Text(
                            a.id,
                            style: dm(
                              12.5,
                              w: FontWeight.w700,
                              color: C.forest,
                              ls: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 25),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Btn(
                      'View my appointments',
                      icon: Icons.arrow_forward,
                      onTap: () {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                        s.setTab(2);
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 16,
                          color: C.muted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Reminder scheduled in CareConnect',
                          style: dm(11, color: C.muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
