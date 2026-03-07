import 'dart:math';

import 'package:keyhole_manager/models/tenant.dart';
import 'package:keyhole_manager/models/violation.dart';

class Room {
  final int floorIndex;
  final int roomIndex;
  Tenant? tenant;
  List<Violation> activeViolations = [];

  Room({
    required this.floorIndex,
    required this.roomIndex,
    this.tenant,
  });

  void randomizeViolations({double chance = 0.3, Random? random}) {
    final rng = random ?? Random();
    activeViolations = [
      for (final v in Violation.values)
        if (rng.nextDouble() < chance) v,
    ];
  }
}
