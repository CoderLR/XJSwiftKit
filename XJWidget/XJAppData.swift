//
//  XJAppData.swift
//  XJWidgetExtension
//
//  Created by xj on 2022/9/28.
//

import WidgetKit
import SwiftUI
import Intents

struct XJAppDataProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> XJAppDataEntry {
        XJAppDataEntry(date: Date(), configuration: XJAppDataIntent())
    }

    // 定义Widget预览中如何展示，所以提供默认值要在这里
    func getSnapshot(for configuration: XJAppDataIntent, in context: Context, completion: @escaping (XJAppDataEntry) -> ()) {
        let entry = XJAppDataEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    // 决定 Widget 何时刷新
    func getTimeline(for configuration: XJAppDataIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [XJAppDataEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = XJAppDataEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct XJAppDataEntry: TimelineEntry {
    let date: Date
    let configuration: XJAppDataIntent
}

struct XJAppDataEntryView : View {
    var entry: XJAppDataProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

//@main
struct XJAppData: Widget {
    let kind: String = "XJAppData"
    var title: String = ""
    var desc: String = ""

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: XJAppDataIntent.self, provider: XJAppDataProvider()) { entry in
            XJAppDataEntryView(entry: entry)
        }
        .configurationDisplayName(title)
        .description(desc)
        .supportedFamilies([.systemLarge])
    }
}
