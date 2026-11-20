import 'models.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
DateTime parseKey(String k) => DateTime.parse('${k}T12:00:00');
String futureDate(int offset) =>
    dateKey(DateTime.now().add(Duration(days: offset)));
String prettyDate(String k) {
  final d = parseKey(k);
  return '${_months[d.month - 1]} ${d.day}, ${d.year}';
}

String monthShort(DateTime d) => _months[d.month - 1];
String weekdayShort(DateTime d) => _weekdays[d.weekday - 1];

const _q = '?auto=format&fit=crop&w=500&q=85';

const List<Doctor> doctors = [
  Doctor(
    id: 1,
    name: 'Dr. Maya Bennett',
    specialty: 'Cardiology',
    qualification: 'MD, FACC',
    experience: 14,
    fee: 120,
    rating: 4.9,
    reviews: 182,
    image: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2$_q',
    available: true,
    about:
        'Dr. Bennett specializes in preventive cardiology and compassionate long-term heart care, with a focus on clear, collaborative treatment plans.',
    days: 'Mon, Wed, Fri',
  ),
  Doctor(
    id: 2,
    name: 'Dr. Ethan Cole',
    specialty: 'Dermatology',
    qualification: 'MD, FAAD',
    experience: 11,
    fee: 95,
    rating: 4.8,
    reviews: 146,
    image: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d$_q',
    available: true,
    about:
        'A board-certified dermatologist providing evidence-based care for skin health, from routine concerns to complex conditions.',
    days: 'Tue, Thu, Sat',
  ),
  Doctor(
    id: 3,
    name: 'Dr. Priya Nair',
    specialty: 'Pediatrics',
    qualification: 'MD, MRCPCH',
    experience: 9,
    fee: 85,
    rating: 4.9,
    reviews: 204,
    image: 'https://images.unsplash.com/photo-1643297654416-05795d62e39c$_q',
    available: true,
    about:
        'Dr. Nair creates a calm, reassuring experience for children and families through every stage of development.',
    days: 'Mon, Tue, Thu',
  ),
  Doctor(
    id: 4,
    name: 'Dr. Marcus Reed',
    specialty: 'Neurology',
    qualification: 'MD, PhD',
    experience: 16,
    fee: 135,
    rating: 4.7,
    reviews: 119,
    image: 'https://images.unsplash.com/photo-1666887360369-1901f341fdad$_q',
    available: false,
    about:
        'Specializing in headaches, movement disorders, and comprehensive neurological assessment.',
    days: 'Wed, Fri',
  ),
  Doctor(
    id: 5,
    name: 'Dr. Elena Rossi',
    specialty: 'General Medicine',
    qualification: 'MD, ABIM',
    experience: 12,
    fee: 75,
    rating: 4.8,
    reviews: 231,
    image: 'https://images.unsplash.com/photo-1659353888906-adb3e0041693$_q',
    available: true,
    about:
        'Thoughtful primary care focused on prevention, continuity, and helping patients feel fully heard.',
    days: 'Mon–Fri',
  ),
  Doctor(
    id: 6,
    name: 'Dr. Noah Williams',
    specialty: 'Orthopedics',
    qualification: 'MD, FRCS',
    experience: 15,
    fee: 125,
    rating: 4.8,
    reviews: 168,
    image: 'https://images.unsplash.com/photo-1612349316228-5942a9b489c2$_q',
    available: true,
    about:
        'Modern orthopedic care for joint, mobility, and sports-related concerns with a recovery-first approach.',
    days: 'Tue, Wed, Sat',
  ),
];

const specialties = [
  'All',
  'Cardiology',
  'Dermatology',
  'Neurology',
  'Pediatrics',
  'General Medicine',
  'Dentistry',
  'Orthopedics',
  'Gynecology',
];
const slots = [
  '9:00 AM',
  '10:30 AM',
  '11:45 AM',
  '1:00 PM',
  '2:00 PM',
  '3:30 PM',
  '4:45 PM',
];

Doctor doctorById(int id) => doctors.firstWhere((d) => d.id == id);
