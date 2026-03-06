# Keyhole Manager

## Project Overview
A Flame game jam entry (Flame Game Jam 2026). Theme: "Big Brother". Diversifier: Procedural Generation.
The player is a building manager who patrols floors, peeks through keyholes to catch rule-breaking tenants, and issues fines. Goal: expand the building as large as possible without going bankrupt.

## Tech Stack
- **Engine:** Flame 1.35.1 (Flutter game engine)
- **State:** flame_bloc for game state management
- **Audio:** flame_audio
- **Language:** Dart (SDK >=3.0.0 <4.0.0)
- **Input:** Gamepad-first design (diversifier: gamepad support)
- **Target:** Web build primary (game jam submission), macOS for dev

## Project Structure
```
lib/
  main.dart              - Entry point
  game/                  - FlameGame subclass, camera, world setup
  components/            - Game entities (manager, tenants, doors, floors, rooms)
  systems/               - Round system, economy, rule enforcement
  ui/                    - HUD overlays (balance, fines, round timer, shop)
  models/                - Data classes (tenant, rule, room, flat)
  config/                - Constants, balance tuning values
assets/
  images/                - Sprites, tilesets
  audio/                 - SFX and music
```

## Key Commands
- `flutter run -d chrome` - Run web build
- `flutter run -d macos` - Run macOS build
- `flutter test` - Run unit tests
- `flutter build web --release` - Release web build for submission

## Conventions
- Use Flame's Component system (extend Component, not raw widgets)
- State management via flame_bloc (BLoC pattern)
- Keep game balance constants in `lib/config/` for easy tuning
- Gamepad-first input design; all UI must be navigable without mouse/keyboard
- Pixel art style, low resolution viewport
- No emoji in code or comments

## Game Jam Constraints
- Deadline is tight — favor working features over polish
- Web build must work for submission
- Keep scope manageable: core loop first, extras later
