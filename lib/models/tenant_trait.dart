import 'package:keyhole_manager/models/violation.dart';

enum TenantTrait {
  partyAnimal([Violation.loudMusic, Violation.parties]),
  petLover([Violation.pets]),
  messyCook([Violation.smellyCooking, Violation.waterOverflow]),
  nightOwl([Violation.lightsOn, Violation.loudMusic]),
  quiet([]);

  const TenantTrait(this.biasedViolations);
  final List<Violation> biasedViolations;
}
