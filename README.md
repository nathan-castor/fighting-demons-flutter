# Fighting Demons 🕯️

> Gamified spiritual wellness app — face off against demons through daily rituals of movement, strength, and stillness.

## Overview

Fighting Demons transforms fitness and meditation into an epic spiritual battle. You're bonded with a Spirit Guide who evolves as you complete daily challenges. The demons are real — they thrive on your inaction. Fight back.

## The Concept

### Three Daily Face-Offs
- **Dawn** 🌅 — Walk/run 1 mile + 10 min meditation
- **Noon** ☀️ — Pushups to failure + 10 min meditation  
- **Dusk** 🌙 — Pullups to failure + 10 min meditation

### Spirit Guide Evolution
Your Spirit Guide starts as a faint **Ember** and evolves through 9 stages as you earn points:

1. 🕯️ **Ember** (0 pts) — A faint flicker, barely holding on
2. 👻 **Shade** (44 pts) — Growing more defined, gaining form
3. ✨ **Specter** (100 pts) — Radiant and strong
4. 🌟 **Wraith** (200 pts) — A force of ethereal power
5. 🛡️ **Guardian** (400 pts) — A powerful protector
6. ⚔️ **Sentinel** (700 pts) — Warrior of the light
7. 👼 **Seraph** (1200 pts) — Transcendent being
8. ☀️ **Radiant** (2000 pts) — Blazing with divine light
9. 🔱 **Ascendant** (3500 pts) — Beyond mortal comprehension

### Lore & World-Building
The app weaves Gnostic, Hermetic, and Stoic wisdom into an immersive narrative. As you progress, you unlock lore entries that reveal the nature of the demons, the origin of Spirit Guides, and the path of ascension.

## Tech Stack

- **Flutter 3.27** — Cross-platform (iOS, Android, Web)
- **Riverpod** — State management
- **GoRouter** — Navigation
- **Supabase** — Auth & Database
- **Rive/Lottie** — Animations (planned)

## Project Structure

```
lib/
├── config/
│   ├── game_config.dart    # Evolution stages, achievements, point math
│   └── lore_data.dart      # Spirit Guide dialog, wisdom entries
├── domain/
│   └── models/
│       ├── user_profile.dart
│       └── daily_record.dart
├── providers/
│   └── providers.dart      # Riverpod providers
├── router/
│   └── app_router.dart     # GoRouter config
├── screens/
│   ├── splash_screen.dart
│   ├── intro_screen.dart
│   ├── auth/
│   ├── home/
│   ├── face_off/
│   ├── profile/
│   ├── lore/
│   └── achievements/
├── services/
│   └── supabase_service.dart
├── theme/
│   └── app_theme.dart
└── main.dart
```

## Setup

1. **Install Flutter:**
   ```bash
   # Already installed at ~/flutter
   export PATH="$HOME/flutter/bin:$PATH"
   ```

2. **Set Supabase credentials:**
   ```bash
   # In your environment or .env
   SUPABASE_URL=your_url
   SUPABASE_ANON_KEY=your_key
   ```

3. **Run the app:**
   ```bash
   cd fighting_demons
   flutter run
   ```

## Supabase Schema (TODO)

The app expects these tables:

### `profiles`
- `id` (uuid, FK to auth.users)
- `email` (text)
- `name` (text)
- `total_points` (int)
- `demon_points` (int)
- `life_force` (int)
- `current_streak` (int)
- `longest_streak` (int)
- `total_miles` (int)
- `total_pushups` (int)
- `total_pullups` (int)
- `total_meditation_minutes` (int)
- `pushup_pr` (int)
- `pullup_pr` (int)
- `intro_seen` (bool)
- `unlocked_achievements` (text[])
- `unlocked_lore` (text[])
- `created_at`, `updated_at`

### `daily_records`
- `id` (uuid)
- `user_id` (uuid, FK)
- `date` (date)
- `dawn_complete`, `noon_complete`, `dusk_complete` (bool)
- `dawn_defers`, `noon_defers`, `dusk_defers` (int)
- `points_earned` (int)
- `miles_walked` (float)
- `pushups_count`, `pullups_count` (int)
- `meditation_minutes` (int)
- `is_perfect_day` (bool)
- `created_at`, `updated_at`

## Next Steps

- [ ] Add Rive animations for Spirit Guide stages
- [ ] Implement meditation timer with haptic feedback
- [ ] Add push notifications for face-off reminders
- [ ] Create evolution celebration animations
- [ ] Add branching dialog tree system
- [ ] Implement death/rebirth mechanic
- [ ] Add social features (leaderboards, guilds)

## Philosophy

> "The demons do not want your destruction. They want your sleep. Wake."

---

Built with 🕯️ by Nate Castor & Athos
