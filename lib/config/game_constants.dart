class GameConstants {
  // Viewport
  static const double viewportWidth = 320;
  static const double viewportHeight = 180;

  // Building
  static const int startingFloors = 6;
  static const int roomsPerFloor = 3;
  static const double floorHeight = 48;
  static const double roomWidth = 80;
  static const double doorWidth = 16;
  static const double doorHeight = 32;
  static const double stairsWidth = 32;

  // Manager
  static const double managerSpeed = 80;
  static const double managerClimbSpeed = 60;
  static const double managerWidth = 16;
  static const double managerHeight = 24;

  // Peek
  static const double peekProximityThreshold = 12.0;

  // Economy
  static const int startingBalance = 100;
  static const int correctReportReward = 25;
  static const int wrongReportPenalty = 15;

  // Day cycle
  static const double dayDurationSeconds = 60.0;
  static const int missedViolationPenalty = 20;
  static const double dayEndPauseDuration = 3.0;
}
