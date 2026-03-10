import 'dart:math';

import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/tenant.dart';
import 'package:keyhole_manager/models/tenant_trait.dart';
import 'package:keyhole_manager/models/violation.dart';

class Room {
  final int floorIndex;
  final int roomIndex;
  Tenant? tenant;
  List<Violation> activeViolations = [];
  bool reported = false;
  Violation? reportedViolation;

  Room({
    required this.floorIndex,
    required this.roomIndex,
    this.tenant,
  });

  bool get hasViolations => activeViolations.isNotEmpty;

  void randomizeViolations({
    required List<Violation> activeRules,
    required int currentDay,
    Random? random,
  }) {
    final rng = random ?? Random();
    final baseChance = _baseChanceForDay(currentDay);
    final trait = tenant?.trait;

    activeViolations = [
      for (final v in activeRules)
        if (rng.nextDouble() < _chanceFor(v, baseChance, trait)) v,
    ];
  }

  static double _baseChanceForDay(int day) {
    if (day <= 3) return GameConstants.violationChanceDay1to3;
    if (day <= 7) return GameConstants.violationChanceDay4to7;
    if (day <= 12) return GameConstants.violationChanceDay8to12;
    return GameConstants.violationChanceDay13plus;
  }

  static double _chanceFor(
    Violation v,
    double baseChance,
    TenantTrait? trait,
  ) {
    if (trait == null) return baseChance;
    if (trait == TenantTrait.quiet) {
      return (baseChance * GameConstants.quietTraitMultiplier).clamp(0.0, 0.9);
    }
    if (trait.biasedViolations.contains(v)) {
      return (baseChance * GameConstants.biasedTraitMultiplier).clamp(0.0, 0.9);
    }
    return baseChance;
  }
}
