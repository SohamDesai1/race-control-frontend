# Fantasy F1 v2 - Frontend Implementation Plan

## Overview
This plan outlines the Flutter frontend screens and architecture needed to consume the Fantasy F1 v2 backend API.

---

## Navigation Structure

**New Bottom Tab**: Add "Fantasy" as 5th tab in bottom navigation

| Tab Index | Screen |
|-----------|--------|
| 0 | Home |
| 1 | Standings |
| 2 | Calendar |
| 3 | **Fantasy** ← NEW |
| 4 | Settings |

---

## Screen Breakdown (Priority Order)

### Phase 1: Core Features (MVP)

#### 1. Fantasy Home Screen (`/fantasy`)
- Quick stats: User's total points, current rank
- "Pick Team for Next GP" CTA button
- List of user's active contests (max 3)
- Quick link to global leaderboard

#### 2. Drivers Screen (`/fantasy/drivers`)
- List of all 22 F1 drivers
- Each card shows: Driver name, team, salary ($M)
- Filter: By team / By salary range
- Search: Driver name

#### 3. Constructors Screen (`/fantasy/constructors`)
- List of all 11 F1 constructors
- Each card shows: Team name, car color, price ($M)

#### 4. Team Builder Screen (`/fantasy/gp/{gp_id}/team`)
- **Budget Display**: "$XX.XM / $100.0M" with progress bar
- **Driver Picker Section**:
  - Grid of available drivers with salaries
  - Tap to select (max 2 drivers)
  - Show selected drivers at top
- **Constructor Picker Section**:
  - Horizontal scroll of constructors with prices
  - Tap to select (1 constructor)
- **Booster Selector** (optional):
  - "Select Booster" button after picking drivers
  - Choose 1 of your 2 drivers for 2x points
- **Validation**:
  - Disable save if over budget (red indicator)
  - Show remaining budget in real-time
- **Actions**: "Save Team" button

#### 5. My Teams Screen (`/fantasy/teams`)
- List of GPs with team status:
  - "Not picked" - greyed out
  - "Pick team" - active GP
  - "Team locked" - after qualifying
  - "Team complete" - with points

---

### Phase 2: Contest Features

#### 6. Contests List Screen (`/fantasy/contests`)
- Tabs: "My Contests" | "Public"
- Each contest card shows:
  - Contest name
  - Type badge ("GP" / "Season")
  - Participants count
  - Your rank (if joined)
- FAB: "Create Contest"

#### 7. Create Contest Screen (`/fantasy/contests/create`)
- Form fields:
  - Contest name (text input)
  - Contest type (segmented: "GP" | "Season")
  - GP selector (dropdown, required for GP type)
  - Invite code (auto-generated, 6 chars)
- Validation: Name required, type required

#### 8. Join Contest Screen (`/fantasy/contests/join`)
- Large text input for invite code
- "Join" button
- Show contest preview before joining

#### 9. Contest Details Screen (`/fantasy/contests/{id}`)
- Header: Contest name, type, GP/Season
- Participants list with avatars + usernames
- Mini leaderboard (top 10)
- "View Full Leaderboard" button
- "Leave Contest" button (if not owner)

---

### Phase 3: Leaderboards

#### 10. GP Leaderboard (`/fantasy/gp/{gp_id}/leaderboard`)
- List of all users who picked teams for this GP
- Columns: Rank | User | Drivers | Constructor | Points
- Highlight current user's row

#### 11. Season Leaderboard (`/fantasy/leaderboard`)
- Global ranking of all users
- Columns: Rank | User | Total Points
- Pull-to-refresh

#### 12. Contest Leaderboard (`/fantasy/contests/{id}/leaderboard`)
- Same as GP leaderboard but filtered to contest

---

## Data Models Needed

```
lib/models/
├── fantasy/
│   ├── fantasy_driver.dart        # Driver with salary
│   ├── fantasy_constructor.dart  # Constructor with price
│   ├── fantasy_team.dart          # User's team for GP
│   ├── fantasy_contest.dart       # Contest metadata
│   ├── fantasy_participant.dart   # Contest participant
│   └── fantasy_leaderboard_entry.dart
```

---

## API Integration

### Endpoints to Consume:

| Method | Endpoint | Screen |
|--------|----------|--------|
| GET | `/fantasy/drivers` | Drivers List |
| GET | `/fantasy/constructors` | Constructors List |
| GET | `/fantasy/gp/{gp_id}` | GP Info + picks available |
| POST | `/fantasy/gp/{gp_id}/team` | Save team |
| GET | `/fantasy/gp/{gp_id}/team` | Get user's team |
| POST | `/fantasy/gp/{gp_id}/booster` | Set booster |
| GET | `/fantasy/gp/{gp_id}/leaderboard` | GP Leaderboard |
| GET | `/fantasy/leaderboard` | Season Leaderboard |
| POST | `/fantasy/contests` | Create contest |
| GET | `/fantasy/contests` | My contests |
| GET | `/fantasy/contests/invite/{code}` | Get by invite |
| POST | `/fantasy/contests/invite/{code}/join` | Join contest |
| GET | `/fantasy/contests/{id}` | Contest details |
| DELETE | `/fantasy/contests/{id}/leave` | Leave contest |
| GET | `/fantasy/contests/{id}/leaderboard` | Contest leaderboard |

---

## Architecture

### Repository Layer
```
lib/repositories/
├── fantasy_repository.dart        # Interface
└── repository_impl/
    └── fantasy_repository_impl.dart
```

### Cubits/States
```
lib/presentation/fantasy/cubit/
├── fantasy_home_cubit.dart       # Home screen state
├── fantasy_drivers_cubit.dart    # Drivers list
├── fantasy_constructors_cubit.dart
├── fantasy_team_builder_cubit.dart
├── fantasy_contests_cubit.dart
└── fantasy_leaderboard_cubit.dart
```

### Datasource
```
lib/datasources/
└── fantasy_datasource.dart      # API calls
```

---

## Implementation Order

1. **Add route constants** in `route_names.dart`
2. **Add API routes** in `api_routes.dart`
3. **Create data models** (freezed)
4. **Create datasource** + repository
5. **Add bottom nav tab** for Fantasy
6. **Build Fantasy Home** → Drivers → Constructors
7. **Build Team Builder** (most complex)
8. **Build Contests** (create/join/list)
9. **Build Leaderboards**
10. **Testing & polish**

---

## Key UI Components to Create

| Component | Purpose |
|-----------|---------|
| `DriverCard` | Driver with salary, selection state |
| `ConstructorCard` | Constructor with price, selection state |
| `BudgetIndicator` | Progress bar showing used/remaining budget |
| `ContestCard` | Contest preview in list |
| `LeaderboardRow` | Rank + user + points |
| `BoosterBadge` | "2x" badge on boosted driver |
| `TeamSummaryCard` | Compact view of selected team |

---

## Notes

- **Budget**: $100M max - validate before API call
- **Team Lock**: Show "Locked" state after qualifying starts
- **Booster**: Only allow after team is saved, must pick from selected drivers
- **Auth**: All endpoints require JWT (handled by existing interceptor)

---

## Theme

- Use existing F1 theme (red/black) to maintain consistency
- Add Fantasy-specific accents where needed
