enum Violation {
  loudMusic('Loud music'),
  pets('Pets'),
  smellyCooking('Smelly cooking'),
  parties('Parties'),
  lightsOn('Lights on'),
  waterOverflow('Water overflow');

  const Violation(this.label);
  final String label;
}
