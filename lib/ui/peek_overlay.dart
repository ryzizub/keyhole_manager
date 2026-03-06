import 'package:flutter/widgets.dart';
import 'package:keyhole_manager/models/room.dart';

class PeekOverlay extends StatelessWidget {
  final Room? room;

  const PeekOverlay({required this.room, super.key});

  @override
  Widget build(BuildContext context) {
    final tenantName = room?.tenant?.name ?? 'Empty';
    final roomLabel = room != null
        ? 'Floor ${room!.floorIndex + 1}, Room ${room!.roomIndex + 1}'
        : 'Unknown';

    return ColoredBox(
      color: const Color(0xDD000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '[ Keyhole View ]',
              style: TextStyle(
                color: Color(0xB3FFFFFF),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              roomLabel,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tenantName,
              style: const TextStyle(
                color: Color(0xFFFFD740),
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Press E / Space / Escape to close',
              style: TextStyle(
                color: Color(0x8AFFFFFF),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
