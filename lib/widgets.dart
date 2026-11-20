import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

Widget hpad(Widget c, {double v = 0}) => Padding(
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: v),
  child: c,
);

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.light = false});
  final String text;
  final bool light;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: dm(
      10,
      w: FontWeight.w700,
      color: light ? const Color(0xFFD7C4A4) : C.gold,
      ls: 1.6,
    ),
  );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 32, this.gold = false});
  final double size;
  final bool gold;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: gold ? C.gold : C.forest,
      borderRadius: BorderRadius.circular(size * .3),
    ),
    child: Icon(Icons.add, color: Colors.white, size: size * .55),
  );
}

enum BtnKind { primary, outline, ghost, danger }

class Btn extends StatelessWidget {
  const Btn(
    this.label, {
    super.key,
    this.onTap,
    this.icon,
    this.kind = BtnKind.primary,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final BtnKind kind;

  @override
  Widget build(BuildContext context) {
    Color bg = C.forest, fg = Colors.white;
    BorderSide side = BorderSide.none;
    if (kind == BtnKind.outline) {
      bg = Colors.white;
      fg = C.ink;
      side = const BorderSide(color: Color(0xFFD9DDD8));
    } else if (kind == BtnKind.ghost) {
      bg = Colors.transparent;
      fg = C.forest;
    } else if (kind == BtnKind.danger) {
      bg = C.error;
    }
    return Material(
      color: bg,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: side,
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: dm(14.5, w: FontWeight.w700, color: fg),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, size: 18, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconBtn extends StatelessWidget {
  const IconBtn(
    this.icon, {
    super.key,
    this.onTap,
    this.size = 40,
    this.dot = false,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final bool dot;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: .7),
            border: Border.all(color: C.line),
          ),
          child: Icon(icon, size: 20, color: C.ink),
        ),
        if (dot)
          Positioned(
            right: 9,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: C.gold,
                shape: BoxShape.circle,
                border: Border.all(color: C.ivory, width: 1.5),
              ),
            ),
          ),
      ],
    ),
  );
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader(this.title, {super.key, this.onBack, this.action});
  final String title;
  final VoidCallback? onBack;
  final Widget? action;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 76,
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child:
                onBack != null
                    ? IconBtn(Icons.arrow_back_ios_new, onTap: onBack)
                    : const BrandMark(),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(title, style: manrope(18, w: FontWeight.w700)),
          ),
        ),
        SizedBox(
          width: 60,
          child: Align(alignment: Alignment.centerRight, child: action),
        ),
      ],
    ),
  );
}

class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.hint,
    this.error,
    this.suffix,
    this.keyboard,
    this.obscure = false,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.optional = false,
  });
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String? hint, error;
  final Widget? suffix;
  final TextInputType? keyboard;
  final bool obscure, optional;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int? maxLength;

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c),
  );

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: dm(12, w: FontWeight.w700)),
            if (optional) Text('  Optional', style: dm(11, color: C.muted)),
          ],
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          obscureText: obscure,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          style: dm(14),
          cursorColor: C.forest,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: dm(14, color: const Color(0xFFADB3B0)),
            prefixIcon:
                icon == null
                    ? null
                    : Icon(icon, size: 18, color: const Color(0xFF89918D)),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: _b(C.field),
            enabledBorder: _b(hasErr ? C.error : C.field),
            focusedBorder: _b(hasErr ? C.error : C.forest),
          ),
        ),
        if (hasErr)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(error!, style: dm(11, color: C.error)),
          ),
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key, this.size = 38});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) {
    final initials =
        name
            .trim()
            .split(RegExp(r'\s+'))
            .where((n) => n.isNotEmpty)
            .map((n) => n[0])
            .take(2)
            .join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        gradient: const LinearGradient(
          colors: [Color(0xFFD5DFD7), Color(0xFF9BB3A4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        initials,
        style: manrope(size * .3, w: FontWeight.w700, color: C.forest),
      ),
    );
  }
}

class NetImage extends StatelessWidget {
  const NetImage(this.url, {super.key, this.w, this.h, this.r = 10});
  final String url;
  final double? w, h, r;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(r ?? 0),
    child: SizedBox(
      width: w,
      height: h,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        loadingBuilder:
            (c, child, p) =>
                p == null ? child : Container(color: const Color(0xFFECEEEA)),
        errorBuilder:
            (_, _, _) => Container(
              color: const Color(0xFFE7EBE7),
              child: const Icon(Icons.person_outline, color: C.muted),
            ),
      ),
    ),
  );
}

class AvailabilityPill extends StatelessWidget {
  const AvailabilityPill({
    super.key,
    required this.label,
    this.available = true,
  });
  final String label;
  final bool available;
  @override
  Widget build(BuildContext context) {
    final color = available ? C.success : C.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: available ? const Color(0xFFEBF3EE) : const Color(0xFFF0F1EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: dm(9.5, w: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    this.compact = false,
  });
  final Doctor doctor;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rating = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, size: 14, color: C.gold),
        const SizedBox(width: 3),
        Text('${doctor.rating}', style: dm(11, w: FontWeight.w700)),
      ],
    );
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: C.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetImage(
                doctor.image,
                w: compact ? 67 : 103,
                h: compact ? 78 : 132,
                r: 11,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          compact
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AvailabilityPill(
                            label:
                                doctor.available
                                    ? 'Available today'
                                    : 'Next week',
                            available: doctor.available,
                          ),
                        ),
                        if (compact) const SizedBox(width: 10),
                        rating,
                      ],
                    ),
                    SizedBox(height: compact ? 8 : 9),
                    Text(
                      doctor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: manrope(14.5, w: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: dm(12, w: FontWeight.w600, color: C.forest),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 6),
                      Text(
                        '${doctor.experience} yrs experience · ${doctor.qualification}',
                        style: dm(10.5, color: C.muted),
                      ),
                      const SizedBox(height: 10),
                      Container(height: 1, color: const Color(0xFFEDF0EC)),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${doctor.fee}',
                                  style: dm(13.5, w: FontWeight.w700),
                                ),
                                TextSpan(
                                  text: ' consultation',
                                  style: dm(10.5, color: C.muted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: C.forest,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, this.action, this.onAction, {super.key});
  final String title, action;
  final VoidCallback onAction;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: manrope(16, w: FontWeight.w700)),
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: dm(12, w: FontWeight.w700, color: C.forest),
          ),
        ),
      ],
    ),
  );
}

class SummaryRow extends StatelessWidget {
  const SummaryRow(
    this.icon,
    this.label,
    this.value, {
    super.key,
    this.last = false,
  });
  final IconData icon;
  final String label, value;
  final bool last;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(
      border:
          last
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFFEDF0EC))),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: C.tint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 19, color: C.forest),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: dm(10, color: C.muted)),
              const SizedBox(height: 2),
              Text(value, style: dm(12.5, w: FontWeight.w700)),
            ],
          ),
        ),
      ],
    ),
  );
}

class CenterState extends StatelessWidget {
  const CenterState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });
  final IconData icon;
  final String title, body;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 58, horizontal: 25),
    child: Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEEA),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, size: 28, color: C.forest),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: manrope(20, w: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        Text(
          body,
          textAlign: TextAlign.center,
          style: dm(13, color: C.muted, h: 1.5),
        ),
        if (action != null) ...[const SizedBox(height: 18), action!],
      ],
    ),
  );
}

Future<T?> showAppSheet<T>(
  BuildContext context, {
  required String title,
  required Widget child,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  backgroundColor: C.ivory,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
  ),
  builder:
      (ctx) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          22,
          20,
          22,
          27 + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: manrope(18, w: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
);
