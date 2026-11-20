import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'booking.dart';

void openDoctor(BuildContext context, Doctor d) => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: d)),
);

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});
  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final search = TextEditingController();
  String specialty = 'All';
  bool availableOnly = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = search.text.toLowerCase();
    final results =
        doctors
            .where(
              (d) =>
                  (specialty == 'All' || d.specialty == specialty) &&
                  (!availableOnly || d.available) &&
                  '${d.name} ${d.specialty}'.toLowerCase().contains(q),
            )
            .toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          hpad(
            ScreenHeader(
              'Explore doctors',
              action: IconBtn(
                Icons.tune,
                dot: availableOnly,
                onTap: () => setState(() => availableOnly = !availableOnly),
              ),
            ),
          ),
          hpad(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Find care that fits you.', style: manrope(24)),
                const SizedBox(height: 5),
                Text(
                  'Browse trusted specialists and choose a time that works.',
                  style: dm(13, color: C.muted),
                ),
              ],
            ),
          ),
          hpad(
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: search,
                onChanged: (_) => setState(() {}),
                style: dm(14),
                cursorColor: C.forest,
                decoration: InputDecoration(
                  hintText: 'Doctor name or specialty',
                  hintStyle: dm(14, color: C.muted),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 19,
                    color: C.muted,
                  ),
                  suffixIcon:
                      q.isEmpty
                          ? null
                          : IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 17,
                              color: C.muted,
                            ),
                            onPressed: () => setState(search.clear),
                          ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: C.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: C.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: C.forest),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: specialties.length,
              separatorBuilder: (_, _) => const SizedBox(width: 7),
              itemBuilder: (_, i) {
                final s = specialties[i];
                final on = s == specialty;
                return GestureDetector(
                  onTap: () => setState(() => specialty = s),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: on ? C.forest : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: on ? C.forest : C.line),
                    ),
                    child: Text(
                      s,
                      style: dm(11.5, color: on ? Colors.white : C.muted),
                    ),
                  ),
                );
              },
            ),
          ),
          hpad(
            Padding(
              padding: const EdgeInsets.only(top: 21, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loading
                        ? 'Finding specialists…'
                        : '${results.length} specialists',
                    style: dm(11.5, w: FontWeight.w700, color: C.muted),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => availableOnly = !availableOnly),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                availableOnly
                                    ? C.success
                                    : const Color(0xFFB7BDB9),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Available now',
                          style: dm(
                            11.5,
                            w: FontWeight.w700,
                            color: availableOnly ? C.success : C.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loading) ...[
            for (var i = 0; i < 3; i++)
              hpad(
                Container(
                  height: 156,
                  margin: const EdgeInsets.only(bottom: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Row(
                    children: [
                      Container(
                        width: 103,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECEEEA),
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            for (final w in [1.0, .7, .45])
                              FractionallySizedBox(
                                widthFactor: w,
                                child: Container(
                                  height: 10,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECEEEA),
                                    borderRadius: BorderRadius.circular(8),
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
          ] else if (results.isEmpty)
            CenterState(
              icon: Icons.search,
              title: 'No doctors found',
              body:
                  'Try another name, specialty, or remove the availability filter.',
              action: SizedBox(
                width: 160,
                child: Btn(
                  'Clear filters',
                  kind: BtnKind.outline,
                  onTap:
                      () => setState(() {
                        search.clear();
                        specialty = 'All';
                        availableOnly = false;
                      }),
                ),
              ),
            )
          else
            for (final d in results)
              hpad(
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: DoctorCard(
                    doctor: d,
                    onTap: () => openDoctor(context, d),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key, required this.doctor});
  final Doctor doctor;

  Widget _section(String title, Widget child) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: manrope(15, w: FontWeight.w700)),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final d = doctor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 278,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 310,
                    child: NetImage(d.image, r: 0),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 310,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x66142822)],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconBtn(
                            Icons.arrow_back_ios_new,
                            onTap: () => Navigator.pop(context),
                          ),
                          const IconBtn(Icons.favorite_border),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: cardBox(r: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AvailabilityPill(
                                label: 'Accepting appointments',
                              ),
                              const SizedBox(height: 9),
                              Text(
                                d.name,
                                style: manrope(20, w: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${d.specialty} · ${d.qualification}',
                                style: dm(12, color: C.muted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          decoration: const BoxDecoration(
                            border: Border(left: BorderSide(color: C.line)),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.star, size: 16, color: C.gold),
                              Text(
                                '${d.rating}',
                                style: dm(15, w: FontWeight.w700),
                              ),
                              Text(
                                '${d.reviews} reviews',
                                style: dm(9, color: C.muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: C.tint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          for (final e
                              in [
                                ('${d.experience}', 'Years experience'),
                                ('\$${d.fee}', 'Consultation fee'),
                                ('${d.days.split(',').length}', 'Working days'),
                              ].indexed) ...[
                            if (e.$1 > 0)
                              const VerticalDivider(
                                width: 1,
                                color: Color(0xFFD9DFDA),
                              ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    e.$2.$1,
                                    style: manrope(16, w: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(e.$2.$2, style: dm(10, color: C.muted)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _section(
                    'About',
                    Text(d.about, style: dm(13, color: C.muted, h: 1.6)),
                  ),
                  _section(
                    'Availability',
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: cardBox(r: 13),
                      child: Row(
                        children: [
                          Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                              color: C.tint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: C.forest,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Working days',
                                  style: dm(12, w: FontWeight.w700),
                                ),
                                Text(d.days, style: dm(10.5, color: C.muted)),
                              ],
                            ),
                          ),
                          Text(
                            'Next: Tomorrow',
                            style: dm(10.5, color: C.success),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _section(
                    'Next available times',
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in ['9:00 AM', '10:30 AM', '2:00 PM'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: cardBox(r: 9),
                            child: Text(t, style: dm(11.5)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: C.line)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Consultation', style: dm(10, color: C.muted)),
                    Text('\$${d.fee}', style: manrope(18, w: FontWeight.w700)),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Btn(
                    'Book appointment',
                    icon: Icons.arrow_forward,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(doctor: d),
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
