//
//  SenzuWidget.swift
//  SenzuWidget
//
//  iOS home-screen widget: shows today's calories consumed vs. goal.
//
//  Reads the shared UserDefaults suite (App Group) that the Flutter app
//  writes via `WidgetDataService`. Until the widget extension target is
//  added in Xcode (see implementation plan §22), this file is staged but
//  not part of the build.
//

import WidgetKit
import SwiftUI

/// The App Group suite shared with the main app. Must match
/// `kWidgetAppGroupId` in `lib/services/widget_data_service.dart`.
let kAppGroupId = "group.com.koombastudios.senzuApp"

struct CalorieSnapshot {
  let consumed: Int
  let goal: Int

  var remaining: Int { max(0, goal - consumed) }
  var progress: Double { goal > 0 ? min(1.0, Double(consumed) / Double(goal)) : 0 }

  static let placeholder = CalorieSnapshot(consumed: 1240, goal: 2000)
}

struct CalorieProvider: TimelineProvider {
  func placeholder(in context: Context) -> CalorieEntry {
    CalorieEntry(date: Date(), snapshot: .placeholder)
  }

  func getSnapshot(in context: Context, completion: @escaping (CalorieEntry) -> Void) {
    completion(CalorieEntry(date: Date(), snapshot: loadSnapshot()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<CalorieEntry>) -> Void) {
    completion(Timeline(entries: [CalorieEntry(date: Date(), snapshot: loadSnapshot())], policy: .after(Date().addingTimeInterval(15 * 60))))
  }

  private func loadSnapshot() -> CalorieSnapshot {
    let defaults = UserDefaults(suiteName: kAppGroupId)
    let consumed = defaults?.integer(forKey: "senzu_calories_consumed") ?? 0
    let goal = defaults?.integer(forKey: "senzu_calorie_goal") ?? 0
    return CalorieSnapshot(consumed: consumed, goal: goal)
  }
}

struct CalorieEntry: TimelineEntry {
  let date: Date
  let snapshot: CalorieSnapshot
}

struct SenzuWidgetEntryView: View {
  var entry: CalorieEntry

  var body: some View {
    ZStack {
      ContainerRelativeShape()
        .fill(Color(red: 0.043, green: 0.039, blue: 0.063)) // #0B0A10
      VStack(alignment: .leading, spacing: 6) {
        Text("CALORIES")
          .font(.system(size: 10, weight: .medium))
          .tracking(0.5)
          .foregroundColor(Color(red: 0.59, green: 0.56, blue: 0.62))
        Text("\(entry.snapshot.remaining)")
          .font(.system(size: 34, weight: .bold))
          .foregroundColor(.white)
        Text("kcal left")
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(Color(red: 0.59, green: 0.56, blue: 0.62))
        GeometryReader { geo in
          ZStack(alignment: .leading) {
            Capsule().fill(Color.white.opacity(0.12))
            Capsule()
              .fill(
                LinearGradient(
                  colors: [Color(red: 1.0, green: 0.56, blue: 0.37), Color(red: 1.0, green: 0.83, blue: 0.43)],
                  startPoint: .leading,
                  endPoint: .trailing
                )
              )
              .frame(width: geo.size.width * entry.snapshot.progress)
          }
        }
        .frame(height: 6)
        Text("\(entry.snapshot.consumed) / \(entry.snapshot.goal) kcal")
          .font(.system(size: 10, weight: .medium))
          .foregroundColor(Color(red: 0.59, green: 0.56, blue: 0.62))
      }
      .padding(14)
    }
    .containerBackground(for: .widget) {
      Color(red: 0.043, green: 0.039, blue: 0.063)
    }
  }
}

@main
struct SenzuWidget: Widget {
  let kind: String = "SenzuWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: CalorieProvider()) { entry in
      SenzuWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Today's calories")
    .description("Your remaining calories for today at a glance.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
