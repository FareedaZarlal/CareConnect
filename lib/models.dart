enum ApptStatus { upcoming, completed, cancelled }

enum NoticeKind { booked, reminder, cancelled, rescheduled }

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.experience,
    required this.fee,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.available,
    required this.about,
    required this.days,
  });
  final int id;
  final String name, specialty, qualification, image, about, days;
  final int experience, fee, reviews;
  final double rating;
  final bool available;
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });
  final String name, email, phone;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
  };
  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    name: j['name'] as String,
    email: j['email'] as String,
    phone: j['phone'] as String,
  );
}

class Appointment {
  const Appointment({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.patient,
    required this.phone,
    required this.reason,
    required this.status,
  });
  final String id, date, time, patient, phone, reason;
  final int doctorId;
  final ApptStatus status;

  Appointment copyWith({ApptStatus? status}) => Appointment(
    id: id,
    doctorId: doctorId,
    date: date,
    time: time,
    patient: patient,
    phone: phone,
    reason: reason,
    status: status ?? this.status,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'date': date,
    'time': time,
    'patient': patient,
    'phone': phone,
    'reason': reason,
    'status': status.name,
  };

  factory Appointment.fromJson(Map<String, dynamic> j) => Appointment(
    id: j['id'] as String,
    doctorId: j['doctorId'] as int,
    date: j['date'] as String,
    time: j['time'] as String,
    patient: j['patient'] as String,
    phone: j['phone'] as String,
    reason: j['reason'] as String,
    status: ApptStatus.values.byName(j['status'] as String),
  );
}

class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.read,
    required this.kind,
  });
  final int id;
  final String title, body, time;
  final bool read;
  final NoticeKind kind;

  Notice copyWith({bool? read}) => Notice(
    id: id,
    title: title,
    body: body,
    time: time,
    read: read ?? this.read,
    kind: kind,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'time': time,
    'read': read,
    'kind': kind.name,
  };

  factory Notice.fromJson(Map<String, dynamic> j) => Notice(
    id: j['id'] as int,
    title: j['title'] as String,
    body: j['body'] as String,
    time: j['time'] as String,
    read: j['read'] as bool,
    kind: NoticeKind.values.byName(j['kind'] as String),
  );
}
