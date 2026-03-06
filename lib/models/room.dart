import 'package:keyhole_manager/models/tenant.dart';

class Room {
  final int floorIndex;
  final int roomIndex;
  Tenant? tenant;

  Room({
    required this.floorIndex,
    required this.roomIndex,
    this.tenant,
  });
}
