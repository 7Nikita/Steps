//
//  StepsWidget.swift
//  StepsWidget
//
//  Created by Nikita Pekurin on 6.01.21.
//

import WidgetKit
import SwiftUI

private let appGroupKey = "group.com.pnikita.Steps"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StepEntry {
        StepEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (StepEntry) -> ()) {
        let entry = StepEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = StepEntry()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: entry.date)!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        
        entry.getSteps {
            completion(timeline)
        }
    }
}

class StepEntry: TimelineEntry {
    var date: Date
    var steps: Double = 0.0
    
    init() {
        date = Date()
    }
    
    func getSteps(completion: @escaping () -> Void) {
        HKHelper.shared?.getStepsCount { (query, statistics, error) in
            guard let statistics = statistics else { return }
            self.steps = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
            completion()
        }
    }
}

struct StepsWidgetEntryView : View {
    @State var entry: Provider.Entry
    
    @AppStorage("dailyGoal", store: UserDefaults(suiteName: appGroupKey))
    var desiredValue: Double = 0.0

    var body: some View {
        ProgressBar(progress: $entry.steps,
                    target: $desiredValue)
            .frame(width: 100.0, height: 100.0)
            .padding(40.0)
    }
}

@main
struct StepsWidget: Widget {
    let kind: String = "StepsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StepsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Steps")
        .description("Keep track of your daily steps progress.")
        .supportedFamilies([.systemSmall])
    }
}

struct StepsWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepsWidgetEntryView(entry: StepEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
