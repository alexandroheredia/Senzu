# Senzu — Implementation Plan: Complete Calorie Tracker

**Status:** Complete — all 17 in-scope items shipped + recipes v2; iOS widget/HealthKit Dart layer shipped (Xcode steps documented) · **Date:** 2026-08-03 · **Scope:** 17 of 22 improvement points (see below)

## TL;DR

Senzu already has a strong logging core (dashboard ring, collapsible meals, quick-add, barcode + AI label capture, custom meals, shelf, weekly/monthly stats). This plan closes the gaps that keep it from being a _complete_ calorie tracker:

1. **Phase 1 (correctness):** edit logged entries, edit shelf foods, allow future-day planning.
2. **Phase 2 (personalization):** onboarding wizard, BMR/TDEE auto-goal, macro targets, profile editing.
3. **Phase 3 (food database):** search-by-name via OpenFoodFacts, catalog name search, recipes.
4. **Phase 4 (progress & habit):** weight tracking, weekly summary, streaks, reminders.
5. **Phase 5 (account & platform):** account management, offline persistence, iOS widget / HealthKit.

Excluded from the near-term scope: quick log without a meal (4), water tracking (11), exercise logging (13), data export (19), units toggle (21).

---

## Architecture notes this plan assumes

- **State:** Riverpod (`flutter_riverpod`). Widgets `watch` providers from `lib/services/data_providers.dart`; one-off writes go through `context.repos.*` (see `lib/shared/auth_scope.dart` → `UserScope` extension and `lib/services/user_repositories.dart`).
- **Repositories** are uid-bound, constructed per signed-in user in `UserRepositories` (`shelf`, `meals`, `foodLog`, `user`).
- **Design system:** every screen uses `context.appColors` tokens and the shared widgets in `lib/shared/widgets/` (`GlassCard`, `GlassRow`, `GlassInput`, `GlassSegmentedControl`, `GradientButton`, `GlassNavBar`, `EmptyState`, `HeroRing`, `MacroRing`). New screens must follow the same system — no hardcoded hex, no Material defaults.
- **Entry schema:** `FoodEntry` documents are built by `lib/services/entry_builder.dart` (`buildFoodEntry`, `buildMealItem`) — the single source of truth for the Firestore map. Schema changes happen there.
- **Validation gate:** after each implementation, `flutter analyze` must be clean and `flutter test` green (workspace instruction: no analyzer errors/warnings/lints anywhere).

---

## Phase 1 — Core correctness

> **Status: ✅ SHIPPED** (2026-08-03) — edit entry, edit shelf food, and future-day
> logging are implemented; analyzer clean and 37 tests green.

### 1. Edit logged entries

**Status: ✅ Implemented**

**Goal:** users can fix a typo, change a portion, or move a logged food between meals.

**Current state:** `FoodLogRepository` (`lib/services/food_log_repository.dart`) has only `addEntry` and `deleteEntry`. Entry tiles in `dashboard_tab.dart` (`_EntryTile`) support long-press → delete only. No update path exists anywhere.

**Approach:**

- Add `Future<void> updateEntry(String entryId, Map<String, dynamic> data)` to `FoodLogRepository` (`_entries.doc(entryId).update(data)`).
- Reuse `FoodDetails` (`lib/screens/food_tracker/ui/food_shelf/food_details.dart`) in an editing mode:
  - New optional constructor params: `FoodEntry? editingEntry`.
  - When set: prefill portion from `editingEntry.portionSize`, meal picker from `editingEntry.mealType`, date from `editingEntry.dateAdded`; the confirm button becomes "Update".
  - On save: rebuild the map via `buildFoodEntry` (same scaling logic) and call `updateEntry` instead of `addEntry`; keep `foodId`/`dateAdded` consistent.
- Wire entry tiles: tap → `FoodDetails(editingEntry: entry)` (currently taps do nothing — they only long-press to delete). Keep long-press → delete.
- Add a "Delete" action inside the edit screen too, so both paths are reachable from one place.

**Files:** `food_log_repository.dart`, `food_details.dart`, `dashboard_tab.dart`, `entry_builder.dart` (no change needed — builder already takes a date).

### 2. Edit shelf foods

**Status: ✅ Implemented**

**Goal:** correct a wrong calorie/nutrient value on a saved shelf food without re-entering it.

**Current state:** `ShelfRepository` (`lib/services/shelf_repository.dart`) has `addFood`, `deleteFood`, `incrementTimesAdded`. Shelf rows in `shelf_tab.dart` support tap → `FoodDetails`, long-press → delete. No update.

**Approach:**

- Add `Future<void> updateFood(String foodId, Map<String, dynamic> data)` to `ShelfRepository` (`_shelf.doc(foodId).update(data)` or `set(merge: true)`).
- Reuse `AddFood` (`lib/screens/food_tracker/ui/add_food.dart`) in editing mode:
  - New optional param `ShelfFood? editingFood`. Prefill all controllers from it (mirror `_fillFromDraft`), set `foodIdValue: editingFood.foodId`, and switch the save button to "Save changes" → `updateFood` + optionally re-upsert to the global catalog if a barcode exists.
  - Title becomes "Edit food".
- Wire a "Edit" affordance on shelf rows (e.g. tap opens `FoodDetails` as today, but add a trailing edit icon or an "Edit" option in the long-press menu).

**Files:** `shelf_repository.dart`, `add_food.dart`, `shelf_tab.dart`.

### 3. Future-day / meal planning

**Status: ✅ Implemented**

**Goal:** log tomorrow's breakfast or pre-plan meals in advance.

**Current state:** `dashboard_tab.dart` `_pickDate` uses `lastDate: DateTime.now()`, so the picker cannot go past today; `_shiftDate` also refuses forward moves past today.

**Approach:**

- Remove the `lastDate` cap (keep `firstDate: DateTime(2015)`); allow `_shiftDate(1)` beyond today.
- Date nav label logic: show weekday/date for future days ("Tue 5 Aug") instead of the Today/Yesterday logic (which is only valid for ≤ today).
- Firestore already stores `dateAdded` as the query key, so logging to a future date works with zero schema changes — entries are keyed per day everywhere (`dayEntries`, `mealEntries`).
- Optional polish: mark future days in the dashboard (dimmed ring, "planned" styling on sections) so users can tell planned vs. logged at a glance.

**Files:** `dashboard_tab.dart`.

---

## Phase 2 — Personalization

> **Status: ✅ SHIPPED** (2026-08-03) — onboarding wizard, BMR/TDEE auto-goal,
> macro goals, and profile editing are implemented; analyzer clean and 49 tests
> green.

### 5. Onboarding wizard

**Status: ✅ Implemented**

**Goal:** collect the profile data the schema already has, once, at first run.

**Current state:** `auth_controller.dart` `registerWithEmailAndPassword` seeds every new user with hardcoded `('male', 'sedentary', 2400)`. `AppUser` has `sex`, `activityLevel`, `username` fields that are never set from the UI. The old `InitialProfileSetup` wizard was deleted as dead code and never replaced. `ProfileTab` greeting falls back to "Hey, there!" because `username` is never editable.

**Approach:**

- Add an onboarding flag to the user doc: `onboardingComplete: bool` (default false in the seed).
- Build a new wizard screen (glass, design-system-styled) collecting:
  1. Name (`username`)
  2. Sex (`sex`: male/female)
  3. Activity level (`activityLevel`: sedentary / slightly_active / active / very_active — existing enum values)
  4. Height & weight (new fields, see §6)
  5. Suggested calorie goal (auto-computed via BMR, editable)
- Gate: in the `Home` shell (`home_page.dart`), if `userDataProvider` shows `onboardingComplete == false`, show the wizard before the 4-tab shell (or as a full-screen overlay once).
- Save via a new `UserRepository.updateOnboarding(...)` (one `set` with all fields).

**Files:** `models/user.dart` (+ fields), `user_repository.dart`, new `lib/screens/onboarding/onboarding_screen.dart`, `home_page.dart`, `auth_controller.dart` (seed default), `auth_scope.dart` (unchanged).

### 6. BMR/TDEE auto-goal

**Status: ✅ Implemented**

**Goal:** the calorie goal becomes a computed suggestion, not a hardcoded guess.

**Current state:** `dailyCaloriesGoal` defaults to 2400 for everyone; `goals.dart` edits it as a bare number. `sex`/`activityLevel` exist but nothing consumes them.

**Approach:**

- Add a small pure helper `lib/services/calorie_calculator.dart`:
  - Mifflin-St Jeor BMR: male `10w + 6.25h − 5a + 5`, female `10w + 6.25h − 5a − 161` (w kg, h cm, a years).
  - TDEE = BMR × activity multiplier (sedentary 1.2, slightly_active 1.375, active 1.55, very_active 1.725).
- Add `heightCm`, `weightKg`, `ageYears` (or `birthDate`) to `AppUser`.
- Onboarding (§5) computes and pre-fills the suggested goal; user can adjust.
- `NutritionGoals` screen (`goals.dart`) shows "Suggested for you: X kcal" next to the manual input.

**Files:** new `lib/services/calorie_calculator.dart` (+ unit tests in `test/`), `models/user.dart`, onboarding screen, `goals.dart`.

### 7. Macro goals

**Status: ✅ Implemented**

**Goal:** the macro rings fill against _your_ targets, not FDA reference values.

**Current state:** dashboard macro rings (`dashboard_tab.dart`) divide by `totalCarbohydrateDailyValue` / `proteinDailyValue` / `totalFatDailyValue` (FDA 2000-calorie references from `daily_values_constants.dart`). Same in `food_details.dart` macro bars and `stats_tab.dart` averages.

**Approach:**

- Add `proteinGoalG`, `carbGoalG`, `fatGoalG` (or a macro split %) to `AppUser`, defaulting to the current FDA values.
- In the dashboard/rings, divide by the user's goals instead of the constants.
- Add a "Macros" section to the goals screen (three numeric fields or a percentage split UI).
- Keep `daily_values_constants.dart` as fallbacks when goals are unset (backwards compatible).

**Files:** `models/user.dart`, `goals.dart` (or a new `macro_goals.dart`), `dashboard_tab.dart`, `food_details.dart`, `stats_tab.dart`.

### 18. Profile editing

**Status: ✅ Implemented**

**Goal:** let users change their name and profile fields after onboarding.

**Current state:** `ProfileTab` shows greeting + static rows (Goals / Nutrient guide / Feedback / Sign out). No edit entry point; `username` never writable.

**Approach:**

- Add an "Edit profile" row to `ProfileTab` (pencil icon next to the avatar or a row under the header).
- New `EditProfileScreen`: glass form for `username`, `sex`, `activityLevel`, `heightCm`, `weightKg`, `age` — same fields as onboarding, reused component.
- Save via `UserRepository` update; recompute suggested goal (offer to apply).

**Files:** new `lib/screens/profile/edit_profile_screen.dart`, `profile_tab.dart`, `user_repository.dart`.

---

## Phase 3 — Food database

> **Status: ✅ SHIPPED** (2026-08-03) — OFF name search, catalog name search,
> three-tier search in `LogFood`, and meal totals + portion editing are
> implemented; analyzer clean and 52 tests green.

### 8. Search-by-name food database

**Status: ✅ Implemented**

**Goal:** search real foods by name, not just the user's own shelf.

**Current state:** `OpenFoodFactsApi` (`lib/services/open_food_facts_api.dart`) exposes only `lookupByBarcode`. `LogFood` searches `shelfStreamProvider` only; empty shelf → "Add a food first" wall.

**Approach:**

- Add `Future<List<FoodDraft>> searchByName(String query, {int limit = 20})` to `OpenFoodFactsApi` using the OFF search endpoint (`/cgi/search.pl` or `/api/v2/search`), mapping results to `FoodDraft` (reuse the existing barcode mapping helpers).
- In `LogFood`: when the local shelf search returns no results (or always when query is 3+ chars), show OFF results under a "From Open Food Facts" section; tapping one prefills `FoodDetails` via `FoodDraft` (same path as a barcode hit).
- Cache/upsert chosen results into the catalog (`foodCatalogRepositoryProvider.upsert`) so repeat scans/search hits are local.

**Files:** `open_food_facts_api.dart`, `log_food.dart`, `food_lookup_service.dart` (optional orchestration), `food_catalog_repository.dart` (upsert already exists).

### 9. Catalog searchable by name

**Status: ✅ Implemented**

**Goal:** the shared global catalog is searchable, so one user's shelf can help another and OFF hits are cached.

**Current state:** `food_catalog_repository.dart` is barcode/id-keyed only (`getByBarcode`, `getById`); no name query. Catalog is written by the barcode flow only.

**Approach:**

- Add `Stream<List<ShelfFood>> searchByName(String query)` or a Firestore query helper on the `foods` collection (simple `where('foodName', '>=', q)` range query, or client-side filter if the catalog stays small).
- In `LogFood` search: local shelf → catalog → OFF (three-tier, mirroring the barcode flow's catalog → API order in `food_lookup_service.dart`).

**Files:** `food_catalog_repository.dart`, `log_food.dart`.

### 10. Recipes

**Status: ✅ v2 shipped** (2026-08-03) — `Recipe` / `RecipeIngredient` models
with per-serving math, `RecipeRepository` + `recipesStreamProvider`, a
`RecipeEditorScreen` (name, servings stepper, ingredient picker from shelf,
live per-serving preview), a Recipes segment in the Shelf tab with one-tap
log-a-serving, and `buildRecipeEntry` in `entry_builder.dart`. Tests in
`test/recipe_test.dart`.

**Current state:** custom meals exist (`MealDetails`, `meal_repository.dart`) but are flat food lists — no quantities, no computed per-serving nutrition, no ingredient editing beyond add/delete.

**Approach (phased):**

- **v1 (light):** extend the existing meal model — allow editing item portion sizes inside `MealDetails`, and show computed totals (kcal + macros) for the meal. This is mostly UI work on top of existing `MealFoodItem` data.
- **v2 (recipes):** new `recipes` collection (`users/{uid}/recipes`) with `name`, `servings`, `ingredients: [{foodId, name, grams, calories, protein, fat, carbs}]`, computed `perServing` nutrition. Screens: recipe list (Shelf tab "Recipes" segment or its own screen), recipe editor, "Log a serving" action that writes a single `FoodEntry` via `buildFoodEntry`.
- Reuse the entry-scaler logic; keep `MealFoodItem`-style ingredient rows.

**Files:** new `models/recipe.dart`, `recipe_repository.dart`, `recipes` screens; `meal_details.dart` (v1 portion editing).

---

## Phase 4 — Progress & habit

> **Status: ✅ SHIPPED** (2026-08-03) — weight tracking, weekly summary,
> streaks, and reminders are implemented; analyzer clean and 58 tests green.

### 12. Weight tracking

**Status: ✅ Implemented**

**Goal:** track body weight over time — the best progress signal in a calorie app.

**Current state:** no weight model, repo, or UI anywhere. `stats_tab.dart` has the chart pattern to build on.

**Approach:**

- New `weightEntries` collection (`users/{uid}/weightEntries`): `{date, weightKg}`.
- `WeightEntry` model + `WeightRepository` (or extend `FoodLogRepository` pattern): `streamEntries`, `addEntry`, `deleteEntry`, `latestEntry`.
- Providers in `data_providers.dart`: `weightEntriesProvider`, `latestWeightProvider`.
- UI:
  - Dashboard: small weight tile under the macros card (latest weight + delta vs. previous).
  - Stats tab: weight line chart alongside the calorie bar chart (segmented Week/Month/All).
  - Entry: "Log weight" sheet from the dashboard tile (quick number + date).

**Files:** new `models/weight_entry.dart`, `weight_repository.dart`, providers, `dashboard_tab.dart`, `stats_tab.dart`; extend `UserRepositories`.

### 16. Weekly summary / report

**Status: ✅ Implemented**

**Goal:** a digest of the week — the data exists, the narrative doesn't.

**Current state:** `stats_tab.dart` shows week/month calorie bars + nutrient averages (via `entriesSinceProvider`). No summary text.

**Approach:**

- Add a summary card at the top of Stats: "You averaged 1,980 kcal/day. Protein was 78% of target. Best day: Friday (2,340 kcal)."
- Pure presentation over existing providers; optionally derive a 7-day streak and most-logged food.

**Files:** `stats_tab.dart`.

### 15. Streaks / consistency

**Status: ✅ Implemented**

**Goal:** motivate with a "days logged in a row" counter.

**Current state:** `foodEntries` already exist per day; nothing counts days.

**Approach:**

- Pure helper over `entriesSinceProvider` data (or a dedicated `lastNDays` query): count consecutive days with ≥1 entry ending today.
- Show in Profile header ("🔥 6-day streak") and/or a small chip on the dashboard.

**Files:** new helper (pure function, unit-testable), `profile_tab.dart` / `dashboard_tab.dart`.

### 14. Reminders

**Status: ✅ Implemented**

**Goal:** daily "log your lunch/dinner" push reminders.

**Current state:** zero notification plumbing (no `flutter_local_notifications`, no permission flow).

**Approach:**

- Add `flutter_local_notifications` dependency; initialize in `main.dart`.
- Settings row in Profile → Reminders: enable/disable + pick time(s) (lunch/dinner defaults).
- Persist schedule locally (`shared_preferences`) or per-user in Firestore; schedule via `zonedSchedule` with exact-alarm permission on Android and provisional permission on iOS.
- Keep it simple: one configurable daily time is enough for v1.

**Files:** new `services/reminder_service.dart`, `profile_tab.dart` (or new `reminders_screen.dart`), `main.dart`, `pubspec.yaml`.

---

## Phase 5 — Account & platform

> **Status: ✅ SHIPPED** (2026-08-03) — account management and offline
> persistence are implemented; the iOS widget / HealthKit stretch is
> documented (needs Apple signing/entitlements, see #22). Analyzer clean
> and 58 tests green.

### 17. Account management

**Status: ✅ Implemented**

**Goal:** change password, delete account, verify email.

**Current state:** `AuthController` (`lib/services/auth_controller.dart`) handles sign in/out/register only. Profile has no account section.

**Approach:**

- Add to `AuthController`: `sendPasswordReset(email)`, `changePassword(newPassword)`, `sendEmailVerification()`, `deleteAccount()` (with Firestore user-data cleanup via a Cloud Function or a client-side cascade delete of `users/{uid}` subcollections).
- New Profile section "Account": rows for Change password / Reset password / Email verification status / Delete account (danger, confirm dialog).

**Files:** `auth_controller.dart`, `profile_tab.dart` or new `account_screen.dart`.

### 20. Offline persistence

**Status: ✅ Implemented**

**Goal:** confirmed, explicit offline support.

**Current state:** Firestore mobile SDKs enable offline persistence by default, but it's never configured or verified explicitly.

**Approach:**

- Explicitly call `FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true)` (or `enablePersistence()`) before first use in `main.dart`.
- Verify reads/streams work offline; add graceful error/empty states (`EmptyState` already exists) for the no-connection case.
- Note: the barcode/AI flows already require connectivity — call this out in README.

**Files:** `main.dart` (or a small `firestore_db.dart` change), README.

### 22. iOS widget / HealthKit

**Status: 🚧 Dart layer shipped — native target needs Xcode (5-min guided steps below)**

**Goal:** today's calories on the home screen widget; weight via HealthKit.

**What's already done (in this branch):**

- `home_widget` + `health` packages added; `pod install` will run on next iOS build.
- **Dart widget layer:** `lib/services/widget_data_service.dart` (`WidgetDataService` +
  `kWidgetAppGroupId = group.com.koombastudios.senzuApp`). The dashboard pushes today's
  kcal + goal to the shared suite on every entries/goal change (`_syncWidget`).
- **Dart HealthKit layer:** `lib/services/health_kit_service.dart` (`HealthKitService`:
  request permission, fetch last 90 days of weight). The weight log sheet has an
  "Import from Health" button wired to it. All calls are defensive — if the native
  capability isn't enabled yet, they fail silently.
- **Info.plist:** `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription` added.
- **Staged native files (not yet in the build):**
  - `ios/SenzuWidget/SenzuWidget.swift` — WidgetKit provider + SwiftUI view (dark, energy
    gradient progress bar, "kcal left").
  - `ios/Runner/Runner.entitlements` and `ios/SenzuWidget/SenzuWidget.entitlements` — App
    Group entitlement pre-written.
- **Recipes v2** is also shipped (see #10).

**Remaining Xcode steps (only you can do these — they need your Developer account):**

1. Open `ios/Runner.xcworkspace` in Xcode.
2. **Add the widget target:** File → New → Target → **Widget Extension** → name it
   `SenzuWidget`, uncheck "Include Configuration Intent". Delete Xcode's generated
   `SenzuWidget.swift` and drag in `ios/SenzuWidget/SenzuWidget.swift`. Set its
   deployment target to 15.0 and your team as the signing team.
3. **Enable the App Group** on BOTH targets (Runner + SenzuWidget):
   Signing & Capabilities → + Capability → App Groups → add
   `group.com.koombastudios.senzuApp`. (The entitlements files are already written;
   Xcode will reference them.)
4. **HealthKit:** Runner target → Signing & Capabilities → + Capability → **HealthKit**.
   (Info.plist strings are already present.)
5. Build to a device/simulator. `pod install` runs automatically for the new
   `health` / `home_widget` pods.

**Android note (freebie):** the same `WidgetDataService` works with the `home_widget`
Android implementation (`SenzuWidgetProvider`) — the manifest receiver is auto-registered
by the plugin.

---

## Cross-cutting notes

- **Schema additions** (Phase 2+): `heightCm`, `weightKg`, `ageYears`, `onboardingComplete`, `proteinGoalG`, `carbGoalG`, `fatGoalG` on `users/{uid}`. All optional with defaults — no migration needed for existing docs since `AppUser.fromMap` already defaults missing fields.
- **New collections:** `weightEntries` (shipped), `recipes` (v2, shipped).
- **Every new screen/widget** must use `context.appColors` + shared widgets; run `flutter analyze` + `flutter test` after each phase.
- **Suggested order:** Phase 1 → 2 → 3 → 4 → 5. Phase 1 is the highest-frequency pain point and the codebase is already shaped for it (shared `entry_builder`, reusable `FoodDetails`/`AddFood`, Riverpod repos).

---

## Status summary (2026-08-03)

| Phase                  | Items                 | Status                                   |
| ---------------------- | --------------------- | ---------------------------------------- |
| 1 — Correctness        | 1, 2, 3               | ✅ Shipped                               |
| 2 — Personalization    | 5, 6, 7, 18           | ✅ Shipped                               |
| 3 — Food database      | 8, 9, 10              | ✅ Shipped (v1 + v2 recipes)             |
| 4 — Progress & habit   | 12, 16, 15, 14        | ✅ Shipped                               |
| 5 — Account & platform | 17, 20                | ✅ Shipped                               |
| 5 — Stretch            | 22 (widget/HealthKit) | 🚧 Dart shipped — Xcode steps documented |

**Out of scope (excluded by request):** 4, 11, 13, 19, 21.
