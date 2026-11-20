import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

final _emailRx = RegExp(r'^\S+@\S+\.\S+$');

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Widget _bar(double w, double h) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: const Color(0xFFE4DFCF),
      borderRadius: BorderRadius.circular(45),
    ),
  );
  Widget _ring(double d) => Container(
    width: d,
    height: d,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0x17FFFFFF)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: (h * .39).clamp(270.0, 400.0),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(color: C.forest),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: .12,
                      child: Transform.rotate(
                        angle: .28,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [_bar(86, 330), _bar(330, 86)],
                        ),
                      ),
                    ),
                    _ring(300),
                    _ring(210),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const BrandMark(size: 44, gold: true),
                            const SizedBox(width: 12),
                            Text(
                              'CareConnect',
                              style: manrope(
                                24,
                                w: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Care, thoughtfully connected.',
                          style: dm(13, color: const Color(0xFFBFCFC8), ls: .4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Eyebrow('YOUR HEALTH, YOUR TIME'),
                    const SizedBox(height: 10),
                    Text(
                      'Exceptional care begins with a simple connection.',
                      style: manrope(29, h: 1.18, ls: -1),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Discover trusted specialists, book with ease, and keep every detail of your care in one calm place.',
                      style: dm(14, color: C.muted, h: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Btn(
                      'Create an account',
                      icon: Icons.arrow_forward,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 5),
                    Btn(
                      'I already have an account',
                      kind: BtnKind.ghost,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Demo: demo@careconnect.app · password123',
                      textAlign: TextAlign.center,
                      style: dm(11, color: const Color(0xFF98A09C)),
                    ),
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

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 26, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const BrandMark(size: 44),
                const SizedBox(width: 10),
                Text(
                  'CareConnect',
                  style: manrope(20, w: FontWeight.w700, color: C.forest),
                ),
              ],
            ),
            ...children,
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: Color(0xFF949B97),
                ),
                const SizedBox(width: 5),
                Text(
                  'Your health information stays private and secure.',
                  style: dm(11, color: const Color(0xFF949B97)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _Back extends StatelessWidget {
  const _Back(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 29),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back_ios_new, size: 16, color: C.muted),
            const SizedBox(width: 5),
            Text(label, style: dm(14, color: C.muted)),
          ],
        ),
      ),
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.eyebrow, this.title, this.body, {this.top = 38});
  final String eyebrow, title, body;
  final double top;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: top),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(eyebrow),
        const SizedBox(height: 10),
        Text(title, style: manrope(29, h: 1.2, ls: -1)),
        const SizedBox(height: 10),
        Text(body, style: dm(14, color: C.muted, h: 1.55)),
      ],
    ),
  );
}

class _Switch extends StatelessWidget {
  const _Switch(this.text, this.action, this.onTap);
  final String text, action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$text ', style: dm(13, color: C.muted)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: dm(13, w: FontWeight.w700, color: C.forest),
          ),
        ),
      ],
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: demoUser.email);
  final password = TextEditingController(text: demoPassword);
  bool show = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    if (email.text.trim().toLowerCase() == demoUser.email &&
        password.text == demoPassword) {
      final state = context.read<AppState>();
      Navigator.of(context).popUntil((r) => r.isFirst);
      state.login(demoUser);
    } else {
      setState(
        () =>
            error =
                'Email or password is incorrect. Try the demo account below.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    children: [
      const _Back('Back'),
      const _Heading(
        'WELCOME BACK',
        'Sign in to your care.',
        'Continue managing your appointments and health journey.',
      ),
      const SizedBox(height: 28),
      AppField(
        label: 'Email address',
        icon: Icons.mail_outline,
        controller: email,
        keyboard: TextInputType.emailAddress,
        error: error,
        onChanged: (_) => setState(() => error = null),
      ),
      const SizedBox(height: 16),
      AppField(
        label: 'Password',
        icon: Icons.lock_outline,
        controller: password,
        obscure: !show,
        onChanged: (_) => setState(() => error = null),
        suffix: IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 18, color: C.muted),
          onPressed: () => setState(() => show = !show),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotScreen()),
              ),
          child: Text(
            'Forgot password?',
            style: dm(12, w: FontWeight.w700, color: C.forest),
          ),
        ),
      ),
      Btn('Sign in', icon: Icons.arrow_forward, onTap: submit),
      _Switch(
        'New to CareConnect?',
        'Create account',
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        ),
      ),
    ],
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController();
  final password = TextEditingController(), confirm = TextEditingController();
  Map<String, String> errors = {};
  bool show = false;

  @override
  void dispose() {
    for (final c in [name, email, phone, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void clear(String k) => setState(() => errors = {...errors, k: ''});

  void submit() {
    final e = <String, String>{};
    if (name.text.trim().isEmpty) e['name'] = 'Please enter your full name.';
    if (!_emailRx.hasMatch(email.text.trim())) {
      e['email'] = 'Enter a valid email address.';
    }
    if (phone.text.replaceAll(RegExp(r'\D'), '').length < 10) {
      e['phone'] = 'Enter a valid phone number.';
    }
    if (password.text.length < 8) e['password'] = 'Use at least 8 characters.';
    if (password.text != confirm.text) e['confirm'] = 'Passwords do not match.';
    setState(() => errors = e);
    if (e.isEmpty) {
      final state = context.read<AppState>();
      Navigator.of(context).popUntil((r) => r.isFirst);
      state.register(
        UserProfile(
          name: name.text.trim(),
          email: email.text.trim(),
          phone: phone.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    children: [
      const _Back('Back'),
      const _Heading(
        'JOIN CARECONNECT',
        'Create your account.',
        'A few details to personalize your care experience.',
        top: 22,
      ),
      const SizedBox(height: 18),
      AppField(
        label: 'Full name',
        icon: Icons.person_outline,
        hint: 'Olivia Martin',
        controller: name,
        error: errors['name'],
        onChanged: (_) => clear('name'),
      ),
      const SizedBox(height: 10),
      AppField(
        label: 'Email address',
        icon: Icons.mail_outline,
        hint: 'you@example.com',
        controller: email,
        keyboard: TextInputType.emailAddress,
        error: errors['email'],
        onChanged: (_) => clear('email'),
      ),
      const SizedBox(height: 10),
      AppField(
        label: 'Phone number',
        icon: Icons.phone_outlined,
        hint: '(415) 555-0142',
        controller: phone,
        keyboard: TextInputType.phone,
        error: errors['phone'],
        onChanged: (_) => clear('phone'),
      ),
      const SizedBox(height: 10),
      AppField(
        label: 'Password',
        icon: Icons.lock_outline,
        hint: 'At least 8 characters',
        controller: password,
        obscure: !show,
        error: errors['password'],
        onChanged: (_) => clear('password'),
        suffix: IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 18, color: C.muted),
          onPressed: () => setState(() => show = !show),
        ),
      ),
      const SizedBox(height: 10),
      AppField(
        label: 'Confirm password',
        icon: Icons.lock_outline,
        hint: 'Repeat password',
        controller: confirm,
        obscure: !show,
        error: errors['confirm'],
        onChanged: (_) => clear('confirm'),
      ),
      const SizedBox(height: 16),
      Btn('Continue', icon: Icons.arrow_forward, onTap: submit),
      _Switch(
        'Already have an account?',
        'Sign in',
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
      ),
    ],
  );
}

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final email = TextEditingController();
  bool sent = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    children: [
      const _Back('Back to sign in'),
      if (sent) ...[
        const SizedBox(height: 90),
        Center(
          child: Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Color(0xFFE5EEE8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mail_outline, size: 30, color: C.forest),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Check your inbox',
          textAlign: TextAlign.center,
          style: manrope(20, w: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        Text(
          'If an account exists for ${email.text.trim()}, we sent password reset instructions.',
          textAlign: TextAlign.center,
          style: dm(13, color: C.muted, h: 1.5),
        ),
        const SizedBox(height: 25),
        Btn('Return to sign in', onTap: () => Navigator.pop(context)),
      ] else ...[
        const _Heading(
          'ACCOUNT RECOVERY',
          'Reset your password.',
          'Enter your email and we’ll send secure reset instructions.',
        ),
        const SizedBox(height: 28),
        AppField(
          label: 'Email address',
          icon: Icons.mail_outline,
          hint: 'you@example.com',
          controller: email,
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        Btn(
          'Send reset link',
          icon: Icons.arrow_forward,
          onTap: () {
            if (_emailRx.hasMatch(email.text.trim())) {
              setState(() => sent = true);
            }
          },
        ),
      ],
    ],
  );
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final Set<String> selected = {'General Medicine'};

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final first = state.user!.name.trim().split(' ').first.toUpperCase();
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 4,
              alignment: Alignment.centerLeft,
              color: const Color(0xFFE1E4DF),
              child: FractionallySizedBox(
                widthFactor: .8,
                child: Container(color: C.forest),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 30, 26, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandMark(),
                  const SizedBox(height: 42),
                  Eyebrow('WELCOME, $first'),
                  const SizedBox(height: 10),
                  Text(
                    'What matters to your care?',
                    style: manrope(30, h: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Select any specialties you’d like to see first. You can change this later.',
                    style: dm(14, color: C.muted, h: 1.55),
                  ),
                  const SizedBox(height: 27),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.9,
                    children:
                        specialties.skip(1).map((s) {
                          final on = selected.contains(s);
                          return GestureDetector(
                            onTap:
                                () => setState(
                                  () =>
                                      on ? selected.remove(s) : selected.add(s),
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    on ? const Color(0xFFEDF1ED) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: on ? C.forest : C.line,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      s,
                                      style: dm(
                                        12.5,
                                        w: FontWeight.w600,
                                        color: on ? C.forest : C.ink,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 21,
                                    height: 21,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: on ? C.forest : null,
                                      border: Border.all(
                                        color:
                                            on
                                                ? C.forest
                                                : const Color(0xFFDCE0DC),
                                      ),
                                    ),
                                    child:
                                        on
                                            ? const Icon(
                                              Icons.check,
                                              size: 15,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(26, 18, 26, 12),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Btn(
                    'Finish setup',
                    icon: Icons.arrow_forward,
                    onTap: state.completeSetup,
                  ),
                  TextButton(
                    onPressed: state.completeSetup,
                    child: Text(
                      'Skip for now',
                      style: dm(14, w: FontWeight.w600, color: C.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
