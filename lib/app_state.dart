import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'data.dart';
import 'db.dart';
import 'models.dart';

const demoUser = UserProfile(
  name: 'Olivia Martin',
  email: 'demo@careconnect.app',
  phone: '(415) 555-0142',
);
const demoPassword = 'password123';

class AppState extends ChangeNotifier {
  final AppDb _db = AppDb.instance;

  bool loaded = false;
  UserProfile? user;
  bool setupPending = false;
  int tab = 0;
  bool reminders = true;
  List<Appointment> appointments = [];
  List<Notice> notices = [];
  Appointment? lastBooked;

  List<Appointment> _seedAppointments() => [
    Appointment(
      id: 'CC-482901',
      doctorId: 1,
      date: futureDate(2),
      time: '10:30 AM',
      patient: 'Olivia Martin',
      phone: '(415) 555-0142',
      reason: 'Annual heart health review',
      status: ApptStatus.upcoming,
    ),
    Appointment(
      id: 'CC-193624',
      doctorId: 5,
      date: futureDate(-18),
      time: '2:00 PM',
      patient: 'Olivia Martin',
      phone: '(415) 555-0142',
      reason: 'Wellness consultation',
      status: ApptStatus.completed,
    ),
  ];

  List<Notice> _seedNotices() => [
    Notice(
      id: 1,
      title: 'Appointment reminder',
      body:
          'Your visit with Dr. Maya Bennett is coming up on ${prettyDate(futureDate(2))} at 10:30 AM.',
      time: '2 hours ago',
      read: false,
      kind: NoticeKind.reminder,
    ),
    const Notice(
      id: 2,
      title: 'Welcome to CareConnect',
      body:
          'Your account is ready. Find a trusted specialist whenever you need care.',
      time: '2 days ago',
      read: true,
      kind: NoticeKind.booked,
    ),
  ];

  Future<void> load() async {
    try {
      await _db.seedIfNeeded(
        appointments: _seedAppointments(),
        notices: _seedNotices(),
      );
      user = await _db.getUser();
      appointments = await _db.getAppointments();
      notices = await _db.getNotices();
      reminders = (await _db.getSetting('reminders')) != 'false';
    } catch (e) {
      debugPrint('Database error: $e');
      appointments = _seedAppointments();
      notices = _seedNotices();
    }
    loaded = true;
    notifyListeners();
  }

  void setTab(int i) {
    tab = i;
    notifyListeners();
  }

  void login(UserProfile u) {
    user = u;
    setupPending = false;
    tab = 0;
    unawaited(_db.saveUser(u));
    notifyListeners();
  }

  void register(UserProfile u) {
    user = u;
    setupPending = true;
    tab = 0;
    unawaited(_db.saveUser(u));
    notifyListeners();
  }

  void completeSetup() {
    setupPending = false;
    notifyListeners();
  }

  void saveUser(UserProfile u) {
    user = u;
    unawaited(_db.saveUser(u));
    notifyListeners();
  }

  void logout() {
    user = null;
    setupPending = false;
    tab = 0;
    unawaited(_db.clearUser());
    notifyListeners();
  }

  void toggleReminders() {
    reminders = !reminders;
    unawaited(_db.setSetting('reminders', reminders.toString()));
    notifyListeners();
  }

  void markAllRead() {
    notices = notices.map((n) => n.copyWith(read: true)).toList();
    unawaited(_db.markAllNoticesRead());
    notifyListeners();
  }

  /// Returns an error message, or null on success.
  String? confirmBooking({
    required Doctor doctor,
    required String date,
    required String time,
    required String patient,
    required String phone,
    required String reason,
    Appointment? rescheduling,
  }) {
    if (date.compareTo(dateKey(DateTime.now())) < 0) {
      return 'Past dates cannot be booked.';
    }
    final taken = appointments.any(
      (a) =>
          a.doctorId == doctor.id &&
          a.date == date &&
          a.time == time &&
          a.status == ApptStatus.upcoming &&
          a.id != rescheduling?.id,
    );
    if (taken) return 'That time was just booked. Please choose another slot.';

    final id = rescheduling?.id ?? 'CC-${100000 + Random().nextInt(900000)}';
    final next = Appointment(
      id: id,
      doctorId: doctor.id,
      date: date,
      time: time,
      patient: patient,
      phone: phone,
      reason: reason,
      status: ApptStatus.upcoming,
    );
    appointments =
        rescheduling != null
            ? appointments.map((a) => a.id == id ? next : a).toList()
            : [next, ...appointments];
    final notice = Notice(
      id: DateTime.now().millisecondsSinceEpoch,
      title:
          rescheduling != null
              ? 'Appointment rescheduled'
              : 'Appointment confirmed',
      body:
          'Your visit with ${doctor.name} is set for ${prettyDate(date)} at $time.',
      time: 'Just now',
      read: false,
      kind: rescheduling != null ? NoticeKind.rescheduled : NoticeKind.booked,
    );
    notices = [notice, ...notices];
    lastBooked = next;
    unawaited(_db.upsertAppointment(next));
    unawaited(_db.insertNotice(notice));
    notifyListeners();
    return null;
  }

  void cancel(Appointment a) {
    final d = doctorById(a.doctorId);
    appointments =
        appointments
            .map(
              (x) =>
                  x.id == a.id ? x.copyWith(status: ApptStatus.cancelled) : x,
            )
            .toList();
    final notice = Notice(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Appointment cancelled',
      body:
          'Your appointment with ${d.name} on ${prettyDate(a.date)} has been cancelled.',
      time: 'Just now',
      read: false,
      kind: NoticeKind.cancelled,
    );
    notices = [notice, ...notices];
    unawaited(_db.setAppointmentStatus(a.id, ApptStatus.cancelled));
    unawaited(_db.insertNotice(notice));
    notifyListeners();
  }
}
