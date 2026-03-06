# Keyhole Manager - Game Design Document

## Concept
You are the manager of an apartment building. Your job is to enforce the house rules by patrolling the hallways, peeking through keyholes, and slapping fines on rule-breakers. Expand your building, manage your finances, and keep order -- or go bankrupt trying.

**Theme:** Big Brother (surveillance, control, invasion of privacy)
**Diversifier:** Gamepad (designed for gamepad input as primary control method)

---

## Core Loop

```
DAY PHASE (one round = one day, fixed duration)
  -> Sun rises, day timer starts
  -> Manager patrols the building (real-time movement)
  -> Peek through keyholes to observe tenants
  -> Spot rule violations -> door gets RED tint
  -> Rush to the door and issue a fine before night falls
  -> Sky gradually shifts from morning to sunset as time passes
  -> Violations not fined by nightfall -> deducted from manager's balance

NIGHT PHASE (between-round)
  -> Day summary: fines issued, violations missed, net income
  -> Collect rent from tenants
  -> Pay building upkeep costs
  -> Spend earnings on upgrades (new floors, better rules, etc.)
  -> Next day begins
```

---

## Gameplay Mechanics

### Movement & Observation
- The manager walks left/right along hallways and uses stairs/elevator between floors
- Each flat has a door with a keyhole
- Pressing interact near a door triggers a **keyhole view** -- a limited, peephole-style peek inside the flat
- The player must identify if a violation is happening based on what they see

### Rules System
- The building has a posted list of **House Rules** (e.g. "No pets", "No loud music after 10pm", "No cooking smelly food", "No more than 2 guests")
- Rules are procedurally selected/generated each game from a pool
- Tenants may or may not break rules -- their behavior is semi-random
- More rules = more potential fines but harder to monitor

### Day/Night Cycle
- Each round represents one day with a fixed duration (~60-90 seconds real-time)
- The day cannot be extended -- when night falls, it's over
- Visual day/night cycle: sky shifts from dawn -> midday -> sunset -> night
- Violations can appear at any point during the day
- The player must spot and fine as many violations as possible before nightfall
- Night phase is the shop/management screen -- no patrolling

### Violation Detection & Fines
- When a violation is spotted through the keyhole, the door gets a **red tint/indicator**
- The manager must reach the door and interact to **issue a fine** before the round ends
- Successfully issued fine: money added to manager's balance
- Unfined violations at round end: the manager pays a penalty from their own balance (covering damages, complaints, etc.)

### Economy
| Income | Cost |
|---|---|
| Rent (per flat per round) | Building upkeep (per floor) |
| Fines (per violation caught) | Missed violation penalties |
| | New floor purchase |
| | Upgrades |

- **Bankruptcy:** If balance drops below zero, game over
- **Goal:** Build the tallest, most profitable apartment building possible

### Building Expansion (Shop Phase)
Between rounds the manager can spend money on:
- **New floor** -- adds a new floor with procedurally generated flats
- **More rules** -- add rules to the house rules list (more things to catch)
- **Speed boots** -- move faster between floors
- **Security camera** -- auto-detects one violation per round
- **Elevator** -- faster vertical movement
- **Night owl tenants** -- some violations now also visible briefly at night (bonus fining window)

---

## Progression & Difficulty

| Round | What Changes |
|---|---|
| Day 1-3 | Small building (1-2 floors), few rules, low violation rate, tutorial-like |
| Day 4-7 | 3-4 floors, more rules added, tenants get sneakier |
| Day 8-12 | 5-6 floors, violations happen faster, upkeep costs rise |
| Day 13+ | Large building, overwhelming amount of activity, pure survival |

Difficulty scales with building size -- more floors means more ground to cover, more keyholes to check, more chances to miss violations.

---

## Controls (Gamepad-First)

| Gamepad | Keyboard (fallback) | Action |
|---|---|---|
| Left Stick / D-Pad | Arrow keys / WASD | Move manager |
| A / Cross | E / Space | Interact (peek keyhole / issue fine) |
| B / Circle | Escape | Back / Cancel |
| Start | Escape | Pause menu |
| Y / Triangle | Tab | View house rules list |
| Bumpers (LB/RB) | Q / E | Quick-switch between floors |

All UI menus (shop, rules list, pause) must be fully navigable with gamepad. No mouse required.

---

## UI / HUD

- **Top bar:** Current balance, day number, day/night indicator (sun position or clock)
- **Side panel (during keyhole peek):** Close-up view of flat interior
- **Door indicators:** Green = compliant, Red = violation detected, Grey = unchecked
- **Between rounds:** Shop overlay with upgrade options, financial summary

---

## Visual Style
- Pixel art, side-view cross-section of the building (like a dollhouse / Fallout Shelter style)
- Dark, slightly oppressive atmosphere fitting the "Big Brother" theme
- Keyhole view is a circular vignette with limited visibility
- Muted color palette with red accents for violations

---

## Audio
- Ambient hallway sounds (creaking, muffled sounds behind doors)
- Distinct sounds when peeking through keyholes
- Alert sound when violation detected
- Cash register SFX for fines
- Ominous background music

---

## MVP Priorities (Game Jam Scope)

### Must Have
1. Manager movement along floors and between floors
2. Keyhole peeking mechanic with simple interior view
3. Rule violation detection and fine issuing with timer
4. Basic economy (rent, fines, penalties, balance)
5. Round system with between-round shop
6. Procedural flat generation (at minimum: random tenant + random violation)
7. Game over on bankruptcy

### Nice to Have
8. Multiple upgrade types in shop
9. Tenant personality system affecting violation frequency
10. Animated keyhole peek view
11. Sound effects and music
12. Score/leaderboard (tallest building reached)

### Stretch Goals
13. Tenant complaints / eviction mechanic
14. Random events (fire inspection, tenant party, plumbing leak)
15. Multiple building visual themes
16. Save/load system
