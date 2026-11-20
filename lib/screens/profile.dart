import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  void _edit() =>
      showAppSheet(context, title: 'Edit profile', child: const _EditForm());

  Widget _row(
    IconData icon,
    String label, {
    String? value,
    VoidCallback? onTap,
    Widget? trailing,
    bool first = false,
    bool last = false,
  }) {
    final r = BorderRadius.vertical(
      top: Radius.circular(first ? 13 : 0),
      bottom: Radius.circular(last ? 13 : 0),
    );
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: r,
        side: const BorderSide(color: C.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: [
              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: C.tint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 19, color: C.forest),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: dm(12.5, w: FontWeight.w700)),
                    if (value != null)
                      Text(value, style: dm(10.5, color: C.muted)),
                  ],
                ),
              ),
              trailing ??
                  const Icon(Icons.chevron_right, size: 17, color: C.muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _group(String title, List<Widget> rows) => Padding(
    padding: const EdgeInsets.only(top: 19),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 7),
          child: Text(
            title.toUpperCase(),
            style: dm(9.5, color: C.muted, ls: 1.2),
          ),
        ),
        ...rows,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final user = s.user;
    if (user == null) return const SizedBox.shrink();
    final stat =
        (String n, String l) => Expanded(
          child: Column(
            children: [
              Text(n, style: manrope(18, w: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(l, style: dm(10, color: C.muted)),
            ],
          ),
        );

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        children: [
          ScreenHeader(
            'Profile',
            action: IconBtn(Icons.edit_outlined, onTap: _edit),
          ),
          Column(
            children: [
              Avatar(user.name, size: 82),
              const SizedBox(height: 10),
              Text(user.name, style: manrope(20, w: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(user.email, style: dm(12, color: C.muted)),
              const SizedBox(height: 7),
              Text(
                'PATIENT SINCE 2024',
                style: dm(9.5, w: FontWeight.w700, color: C.gold, ls: .6),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 21),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: cardBox(r: 14),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  stat(
                    '${s.appointments.where((a) => a.status == ApptStatus.completed).length}',
                    'Completed',
                  ),
                  Container(width: 1, height: 36, color: C.line),
                  stat(
                    '${s.appointments.where((a) => a.status == ApptStatus.upcoming).length}',
                    'Upcoming',
                  ),
                  Container(width: 1, height: 36, color: C.line),
                  stat(
                    '${doctors.where((d) => s.appointments.any((a) => a.doctorId == d.id)).length}',
                    'Doctors',
                  ),
                ],
              ),
            ),
          ),
          _group('Account', [
            _row(
              Icons.person_outline,
              'Personal information',
              value: user.phone,
              onTap: _edit,
              first: true,
            ),
            _row(
              Icons.notifications_none,
              'Appointment reminders',
              last: true,
              trailing: Switch(
                value: s.reminders,
                activeThumbColor: C.forest,
                onChanged: (_) => s.toggleReminders(),
              ),
            ),
          ]),
          _group('Support & privacy', [
            _row(
              Icons.help_outline,
              'Help & support',
              value: 'Chat or email',
              first: true,
            ),
            _row(
              Icons.verified_user_outlined,
              'Privacy & security',
              value: 'Protected',
            ),
            _row(Icons.lock_outline, 'Terms & policies', last: true),
          ]),
          const SizedBox(height: 21),
          InkWell(
            onTap: s.logout,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFECCCCC)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout, size: 19, color: C.error),
                  const SizedBox(width: 8),
                  Text(
                    'Log out',
                    style: dm(12.5, w: FontWeight.w700, color: C.error),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'CareConnect v1.0 · Demo experience',
              style: dm(10, color: const Color(0xFFA0A6A2)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm();
  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  late final TextEditingController name, email, phone;

  @override
  void initState() {
    super.initState();
    final u = context.read<AppState>().user!;
    name = TextEditingController(text: u.name);
    email = TextEditingController(text: u.email);
    phone = TextEditingController(text: u.phone);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppField(
        label: 'Full name',
        icon: Icons.person_outline,
        controller: name,
      ),
      const SizedBox(height: 13),
      AppField(
        label: 'Email',
        icon: Icons.mail_outline,
        controller: email,
        keyboard: TextInputType.emailAddress,
      ),
      const SizedBox(height: 13),
      AppField(
        label: 'Phone',
        icon: Icons.phone_outlined,
        controller: phone,
        keyboard: TextInputType.phone,
      ),
      const SizedBox(height: 18),
      Btn(
        'Save changes',
        icon: Icons.check,
        onTap: () {
          if (name.text.trim().isNotEmpty &&
              RegExp(r'^\S+@\S+\.\S+$').hasMatch(email.text.trim())) {
            context.read<AppState>().saveUser(
              UserProfile(
                name: name.text.trim(),
                email: email.text.trim(),
                phone: phone.text.trim(),
              ),
            );
            Navigator.pop(context);
          }
        },
      ),
    ],
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    const icons = {
      NoticeKind.booked: Icons.check,
      NoticeKind.reminder: Icons.notifications_none,
      NoticeKind.cancelled: Icons.close,
      NoticeKind.rescheduled: Icons.calendar_today_outlined,
    };
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
          children: [
            ScreenHeader(
              'Notifications',
              onBack: () => Navigator.pop(context),
              action: GestureDetector(
                onTap: s.markAllRead,
                child: Text(
                  'Mark all read',
                  style: dm(12, w: FontWeight.w700, color: C.forest),
                ),
              ),
            ),
            if (s.notices.isEmpty)
              const CenterState(
                icon: Icons.notifications_none,
                title: 'You’re all caught up',
                body: 'Appointment updates and reminders will appear here.',
              )
            else
              for (final n in s.notices)
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border(
                      left: BorderSide(
                        color: n.read ? C.line : C.gold,
                        width: n.read ? 1 : 3,
                      ),
                      top: const BorderSide(color: C.line),
                      right: const BorderSide(color: C.line),
                      bottom: const BorderSide(color: C.line),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          color:
                              n.kind == NoticeKind.cancelled
                                  ? const Color(0xFFF7E9E9)
                                  : const Color(0xFFEAF0EB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icons[n.kind],
                          size: 19,
                          color:
                              n.kind == NoticeKind.cancelled
                                  ? C.error
                                  : C.forest,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    n.title,
                                    style: dm(12.5, w: FontWeight.w700),
                                  ),
                                ),
                                Text(n.time, style: dm(10, color: C.muted)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              n.body,
                              style: dm(11.5, color: C.muted, h: 1.45),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            Container(
              margin: const EdgeInsets.only(top: 19),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFECEFE9),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 18,
                    color: C.muted,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: dm(11, color: C.muted, h: 1.5),
                        children: [
                          TextSpan(
                            text: 'In-app reminders are active.\n',
                            style: dm(11, w: FontWeight.w700),
                          ),
                          const TextSpan(
                            text:
                                'Browser notifications aren’t required; reminders appear here while using CareConnect.',
                          ),
                        ],
                      ),
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
