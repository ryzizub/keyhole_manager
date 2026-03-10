import 'dart:math';

class TenantNames {
  static const _firstNames = [
    'Ada', 'Boris', 'Clara', 'Dmitri', 'Elena',
    'Felix', 'Greta', 'Hugo', 'Iris', 'Jan',
    'Kira', 'Liam', 'Mila', 'Niko', 'Olga',
    'Pavel', 'Quinn', 'Rosa', 'Sven', 'Tara',
    'Udo', 'Vera', 'Wren', 'Xena', 'Yuri',
  ];

  static const _lastNames = [
    'Albers', 'Braun', 'Costa', 'Dahl', 'Evans',
    'Frost', 'Grant', 'Holm', 'Ivanov', 'Jung',
    'Klein', 'Lund', 'Marsh', 'Nord', 'Ortiz',
    'Patel', 'Quinn', 'Reyes', 'Stark', 'Thorne',
    'Urban', 'Voss', 'Walsh', 'Xu', 'Zane',
  ];

  static String generate(Random rng) {
    final first = _firstNames[rng.nextInt(_firstNames.length)];
    final last = _lastNames[rng.nextInt(_lastNames.length)];
    return '$first $last';
  }
}
