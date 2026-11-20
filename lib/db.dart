import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models.dart';

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;

  Future<Database> get _database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'careconnect.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user(
            id INTEGER PRIMARY KEY CHECK (id = 1),
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL
          )''');
        await db.execute('''
          CREATE TABLE appointments(
            id TEXT PRIMARY KEY,
            doctor_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL,
            patient TEXT NOT NULL,
            phone TEXT NOT NULL,
            reason TEXT NOT NULL,
            status TEXT NOT NULL
          )''');
        await db.execute('''
          CREATE TABLE notices(
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            time TEXT NOT NULL,
            is_read INTEGER NOT NULL,
            kind TEXT NOT NULL
          )''');
        await db.execute(
          'CREATE TABLE settings(k TEXT PRIMARY KEY, v TEXT NOT NULL)',
        );
      },
    );
  }

  // ---- settings ----
  Future<String?> getSetting(String k) async {
    final db = await _database;
    final rows = await db.query(
      'settings',
      where: 'k = ?',
      whereArgs: [k],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['v'] as String;
  }

  Future<void> setSetting(String k, String v) async {
    final db = await _database;
    await db.insert('settings', {
      'k': k,
      'v': v,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ---- user ----
  Future<UserProfile?> getUser() async {
    final db = await _database;
    final rows = await db.query('user', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return UserProfile(
      name: r['name'] as String,
      email: r['email'] as String,
      phone: r['phone'] as String,
    );
  }

  Future<void> saveUser(UserProfile u) async {
    final db = await _database;
    await db.insert('user', {
      'id': 1,
      'name': u.name,
      'email': u.email,
      'phone': u.phone,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearUser() async {
    final db = await _database;
    await db.delete('user');
  }

  // ---- appointments (newest first = highest rowid first) ----
  Map<String, Object?> _apptRow(Appointment a) => {
    'id': a.id,
    'doctor_id': a.doctorId,
    'date': a.date,
    'time': a.time,
    'patient': a.patient,
    'phone': a.phone,
    'reason': a.reason,
    'status': a.status.name,
  };

  Future<List<Appointment>> getAppointments() async {
    final db = await _database;
    final rows = await db.query('appointments', orderBy: 'rowid DESC');
    return rows
        .map(
          (r) => Appointment(
            id: r['id'] as String,
            doctorId: r['doctor_id'] as int,
            date: r['date'] as String,
            time: r['time'] as String,
            patient: r['patient'] as String,
            phone: r['phone'] as String,
            reason: r['reason'] as String,
            status: ApptStatus.values.byName(r['status'] as String),
          ),
        )
        .toList();
  }

  /// Updates in place if the id exists (reschedule), otherwise inserts (new booking).
  Future<void> upsertAppointment(Appointment a) async {
    final db = await _database;
    final n = await db.update(
      'appointments',
      _apptRow(a),
      where: 'id = ?',
      whereArgs: [a.id],
    );
    if (n == 0) await db.insert('appointments', _apptRow(a));
  }

  Future<void> setAppointmentStatus(String id, ApptStatus status) async {
    final db = await _database;
    await db.update(
      'appointments',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---- notices (newest first) ----
  Future<List<Notice>> getNotices() async {
    final db = await _database;
    final rows = await db.query('notices', orderBy: 'rowid DESC');
    return rows
        .map(
          (r) => Notice(
            id: r['id'] as int,
            title: r['title'] as String,
            body: r['body'] as String,
            time: r['time'] as String,
            read: (r['is_read'] as int) == 1,
            kind: NoticeKind.values.byName(r['kind'] as String),
          ),
        )
        .toList();
  }

  Future<void> insertNotice(Notice n) async {
    final db = await _database;
    await db.insert('notices', {
      'id': n.id,
      'title': n.title,
      'body': n.body,
      'time': n.time,
      'is_read': n.read ? 1 : 0,
      'kind': n.kind.name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> markAllNoticesRead() async {
    final db = await _database;
    await db.update('notices', {'is_read': 1});
  }

  /// First run only. Lists are given newest-first, so insert them in reverse.
  Future<void> seedIfNeeded({
    required List<Appointment> appointments,
    required List<Notice> notices,
  }) async {
    if (await getSetting('seeded') == '1') return;
    for (final a in appointments.reversed) {
      await upsertAppointment(a);
    }
    for (final n in notices.reversed) {
      await insertNotice(n);
    }
    await setSetting('seeded', '1');
  }
}
