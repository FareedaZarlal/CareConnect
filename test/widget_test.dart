import 'package:flutter_test/flutter_test.dart';
import 'package:careconnect/data.dart';

void main() {
  test('prettyDate formats a date key', () {
    expect(prettyDate('2026-11-19'), 'Nov 19, 2026');
  });

  test('doctorById returns the right doctor', () {
    expect(doctorById(1).name, 'Dr. Maya Bennett');
  });
}
