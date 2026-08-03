# Xcode setup: iOS widget + HealthKit

A hands-on walkthrough of the 5 steps in implementation-plan §22. Everything
on the Dart side is already wired — the only missing piece is the native
Xcode target. **Do this in Xcode; the terminal steps are just to verify.**

Time: ~10–15 minutes. You'll need your Mac + Xcode, and a **real iPhone** for
the HealthKit part (it does not work on the simulator).

---

## What's already staged (verify before you start)

| File | Purpose |
| --- | --- |
| `ios/SenzuWidget/SenzuWidget.swift` | The widget itself (pure SwiftUI + WidgetKit, reads shared `UserDefaults`) |
| `ios/Runner/Runner.entitlements` | App Group entitlement for the main app (pre-written) |
| `ios/SenzuWidget/SenzuWidget.entitlements` | App Group entitlement for the widget (pre-written) |
| `ios/Runner/Info.plist` | `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription` (added) |
| `lib/services/widget_data_service.dart` | Pushes kcal + goal to the shared suite; `iOSName: 'SenzuWidget'` |
| `lib/services/health_kit_service.dart` | Requests weight permission + imports 90 days of samples |

Key identifiers (already matched between Dart and Swift — don't change them):

- App Group: **`group.com.koombastudios.senzuApp`**
- Widget kind: **`SenzuWidget`**
- Your team id: **`AXTX7435Y2`** · Bundle id: **`com.koombastudios.senzuApp`**
- Deployment target: **iOS 15.0**

---

## Step 1 — Open the workspace and add the Widget Extension target

1. Open **`ios/Runner.xcworkspace`** in Xcode (not the `.xcodeproj` — the
   workspace picks up the Flutter pods).
2. **File → New → Target…**
3. In the dialog, pick the **Widget Extension** template (under the iOS tab,
   search "widget" if you can't find it).
4. Configure it:
   - **Product Name:** `SenzuWidget` (exact — it's referenced by name in
     `WidgetDataService` and the asset name).
   - **Team:** your team (`AXTX7435Y2`).
   - **Bundle Identifier:** leave Xcode's suggestion
     `com.koombastudios.senzuApp.SenzuWidget`.
   - **Embed in Application:** `Runner`.
   - **Uncheck "Include Configuration Intent"** — we don't need it, and it
     generates a Swift file you'd have to delete.
5. Click **Finish**. Xcode adds the target and generates a few files into a
   new `SenzuWidget/` group.

---

## Step 2 — Replace the generated files with the staged Swift

Xcode's template creates `SenzuWidgetBundle.swift` (with `@main`) and
`SenzuWidget.swift` (its own widget). Our staged file is a **standalone
`@main` widget**, so the template files must go — otherwise you get a
*"multiple @main attributes"* build error.

1. In the `SenzuWidget` group, **delete these generated files** (move to
   Trash):
   - `SenzuWidgetBundle.swift`
   - `SenzuWidget.swift` (the one Xcode just made)
   - any `AppIntent.swift` if it appeared (it shouldn't if you unchecked
     the intent option)
2. **Drag** `ios/SenzuWidget/SenzuWidget.swift` (from the repo) into the
   `SenzuWidget` group. Make sure **"Copy items if needed" is checked** and
   the **SenzuWidget target** is selected.
3. (Optional but tidy) The template also generates a `SenzuWidget.entitlements`
   **inside its own group** — same content as the staged one. You can delete
   Xcode's copy and use the staged one instead, or just leave it; the group
   id matters, not the filename.

Now the widget compiles as a single `@main struct SenzuWidget: Widget` with
kind `"SenzuWidget"` — matching the `iOSName` the Dart service reloads.

---

## Step 3 — Enable the App Group on BOTH targets

This is the step that makes the app and the widget share data. Both must
have the **same** group id.

**Runner (the app):**
1. Select the **Runner** project in the left navigator → **Runner** target →
   **Signing & Capabilities** tab.
2. Click **+ Capability** → choose **App Groups**.
3. Click the **+** under the App Groups list and type
   **`group.com.koombastudios.senzuApp`** (exact).
4. Xcode will create/attach an `Runner.entitlements` file automatically —
   that's fine. If it asks, accept. (The staged `ios/Runner/Runner.entitlements`
   already has this content, so you can alternatively delete Xcode's copy and
   drag the staged one in — same result.)

**SenzuWidget (the widget):**
1. Same target picker, but choose the **SenzuWidget** target →
   **Signing & Capabilities**.
2. **+ Capability → App Groups** → add the **same**
   `group.com.koombastudios.senzuApp`.

> Why the group matters: the Dart service writes kcal/goal to
> `UserDefaults(suiteName: "group.com.koombastudios.senzuApp")`, and the
> Swift widget reads from `UserDefaults(suiteName: kAppGroupId)` with the
> same string. No shared group → the widget shows `0 / 0`.

**Verify:** after this, each target's entitlements file (or the capability
sheet) lists exactly `group.com.koombastudios.senzuApp`.

---

## Step 4 — Add the HealthKit capability (app only)

1. **Runner** target → **Signing & Capabilities** tab.
2. **+ Capability → HealthKit**.
3. Done — no further config. The usage-description strings are already in
   `Info.plist`; the Dart `HealthKitService` and the "Import from Health"
   button in the weight sheet will start working on a real device.

(HealthKit needs no capability on the widget target — the widget never
touches health data.)

---

## Step 5 — Set deployment target + signing, then build

**Deployment target** (if Xcode didn't inherit 15.0):
- For **both** targets: **Build Settings** → search `IPHONEOS_DEPLOYMENT_TARGET`
  → set **15.0** (WidgetKit requires iOS 14+, 15 is already your app's floor).

**Signing:**
- For **both** targets: **Signing & Capabilities** → **Team**: `AXTX7435Y2`.
  For a free personal team this is fine; for the widget you may need your
  paid developer team — Xcode will tell you.

**Build & run:**
1. Select the **Runner** scheme, pick the **iPhone simulator** (widget works
   there), hit **Run**.
2. `flutter run` will trigger `pod install` automatically for the new
   `health` + `home_widget` pods on your next `flutter run`/build.
3. Add the widget: long-press the home screen → **+** → search **"Senzu"** →
   choose **Today's calories**. It should render your latest snapshot
   (tap around in the app to refresh it — the dashboard pushes on every
   entries/goal change).

**HealthKit on a real device:**
- HealthKit is **not available on the simulator** — plug in a real iPhone,
  run the app, open **Today → weight tile → Import from Health**, and grant
  the permission sheet. You should see the past 90 days of weight samples
  backfill your chart.

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `multiple @main attributes` | You didn't delete the generated `SenzuWidgetBundle.swift` — remove it (Step 2). |
| Widget shows `0 / 0 kcal left` | App Group mismatch. Check both targets list exactly `group.com.koombastudios.senzuApp`, then **fully close and relaunch the app once** so iOS creates the group container. |
| `HomeWidget` methods throw | `home_widget` not on iOS yet — the code swallows errors, but ensure `pod install` ran (it does on next build). |
| HealthKit button does nothing | You're on the simulator (needs a real device), or the HealthKit capability isn't on the **Runner** target. |
| Signing error on the widget target | Set the team on the **SenzuWidget** target too — each target signs separately. |
| After adding the target, `flutter run` fails | Close Xcode, run `cd ios && pod install`, reopen the workspace. |
| Widget preview/gallery mismatch | The dashboard only pushes when **viewing today**; open Today and change something (log/delete an entry) to force a refresh. |

---

## What you should see when it works

- **Home screen widget:** dark card, "CALORIES" label, big `kcal left`
  number, an energy-gradient progress bar, and `consumed / goal` at the
  bottom. Tapping the app refreshes it.
- **Health import:** weight log fills with ~90 days of entries; the Stats →
  Weight chart shows the line immediately.
