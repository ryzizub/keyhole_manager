import 'package:keyhole_manager/models/tenant_trait.dart';

class Tenant {
  final String name;
  final TenantTrait trait;

  Tenant({
    required this.name,
    required this.trait,
  });
}
