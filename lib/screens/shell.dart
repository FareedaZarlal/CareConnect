import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'appointments.dart';
import 'explore.dart';
import 'profile.dart';

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    const items = [
      (Icons.home_outlined, Icons.home, 'Home'),
      (Icons.search, Icons.search, 'Explore'),
      (Icons.calendar_today_outlined, Icons.calendar_today, 'Appointments'),
      (Icons.person_outline, Icons.person, 'Profile'),
    ];
    return Scaffold(
      body: IndexedStack(
        index: s.tab,
        children: const [
          HomeTab(),
          ExploreTab(),
          AppointmentsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .96),
          border: const Border(top: BorderSide(color: C.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(items.length, (i) {
                final on = s.tab == i;
                final color = on ? C.forest : const Color(0xFF8B938F);
                return Expanded(
                  child: InkWell(
                    onTap: () => s.setTab(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          on ? items[i].$2 : items[i].$1,
                          size: 22,
                          color: color,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].$3,
                          style: dm(10.5, w: FontWeight.w600, color: color),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final user = s.user;
    if (user == null) return const SizedBox.shrink();
    final ups =
        s.appointments.where((a) => a.status == ApptStatus.upcoming).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    final next = ups.isEmpty ? null : ups.first;
    final hour = DateTime.now().hour;
    final greeting =
        hour < 12
            ? 'GOOD MORNING'
            : (hour < 17 ? 'GOOD AFTERNOON' : 'GOOD EVENING');
    final unread = s.notices.any((n) => !n.read);

    Widget infoRow(
      IconData icon,
      String title,
      String sub,
      VoidCallback onTap, {
      IconData trail = Icons.chevron_right,
    }) => hpad(
      Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: C.line),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF1ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: C.forest),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: dm(13, w: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(sub, style: dm(11, color: C.muted)),
                    ],
                  ),
                ),
                Icon(trail, size: 18, color: C.muted),
              ],
            ),
          ),
        ),
      ),
    );

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          hpad(
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: dm(
                          10,
                          w: FontWeight.w700,
                          color: C.muted,
                          ls: 1.6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Welcome, ${user.name.trim().split(' ').first}',
                        style: manrope(25),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconBtn(
                        Icons.notifications_none,
                        size: 40,
                        dot: unread,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => s.setTab(3),
                        child: Avatar(user.name),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          hpad(
            GestureDetector(
              onTap: () => s.setTab(1),
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(top: 22, bottom: 17),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: cardBox(r: 13),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 19,
                      color: Color(0xFF9AA19D),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Search doctors or specialties',
                      style: dm(13.5, color: const Color(0xFF9AA19D)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          hpad(
            Container(
              height: 183,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: C.forest,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -36,
                    top: 9,
                    child: Container(
                      width: 165,
                      height: 165,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0x1CFFFFFF)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 22,
                    top: 54,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0x38FFFFFF)),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: .14,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: C.gold,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow('PERSONALIZED CARE', light: true),
                        const SizedBox(height: 7),
                        Text(
                          'Find the right care,\nright when you need it.',
                          style: manrope(21, h: 1.3, color: Colors.white),
                        ),
                        const SizedBox(height: 17),
                        GestureDetector(
                          onTap: () => s.setTab(1),
                          child: Container(
                            height: 37,
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Book an appointment',
                                  style: dm(
                                    12,
                                    w: FontWeight.w700,
                                    color: C.forest,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: C.forest,
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
          ),
          SectionTitle('Your next appointment', 'View all', () => s.setTab(2)),
          if (next != null)
            hpad(
              Material(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: C.line),
                ),
                child: InkWell(
                  onTap: () => s.setTab(2),
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF1ED),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${parseKey(next.date).day}'.padLeft(2, '0'),
                                style: manrope(
                                  18,
                                  w: FontWeight.w700,
                                  color: C.forest,
                                ),
                              ),
                              Text(
                                monthShort(parseKey(next.date)).toUpperCase(),
                                style: dm(
                                  9,
                                  w: FontWeight.w700,
                                  color: C.forest,
                                  ls: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 11),
                        NetImage(
                          doctorById(next.doctorId).image,
                          w: 48,
                          h: 54,
                          r: 10,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorById(next.doctorId).name,
                                style: dm(13.5, w: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                doctorById(next.doctorId).specialty,
                                style: dm(11, color: C.muted),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: C.forest,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    next.time,
                                    style: dm(
                                      11,
                                      w: FontWeight.w600,
                                      color: C.forest,
                                    ),
                                  ),
                                ],
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
              ),
            )
          else
            infoRow(
              Icons.calendar_today_outlined,
              'No upcoming appointment',
              'Book with a trusted specialist',
              () => s.setTab(1),
              trail: Icons.add,
            ),
          SectionTitle('Popular specialties', 'See all', () => s.setTab(1)),
          hpad(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  [
                        (Icons.favorite_border, 'Cardiology'),
                        (Icons.add, 'General care'),
                        (Icons.verified_user_outlined, 'Dermatology'),
                        (Icons.person_outline, 'Pediatrics'),
                      ]
                      .map(
                        (e) => GestureDetector(
                          onTap: () => s.setTab(1),
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: cardBox(r: 15),
                                child: Icon(e.$1, size: 22, color: C.forest),
                              ),
                              const SizedBox(height: 7),
                              Text(e.$2, style: dm(10.5, w: FontWeight.w600)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          SectionTitle('Recommended for you', 'Explore', () => s.setTab(1)),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder:
                  (_, i) => SizedBox(
                    width: 290,
                    child: DoctorCard(
                      compact: true,
                      doctor: doctors[i],
                      onTap: () => openDoctor(context, doctors[i]),
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 22),
          infoRow(
            Icons.access_time,
            'Appointment history',
            'View your past consultations and details',
            () => s.setTab(2),
          ),
        ],
      ),
    );
  }
}
