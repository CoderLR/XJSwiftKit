//
//  XJWidget.swift
//  XJWidget
//
//  Created by xj on 2022/9/27.
//

import WidgetKit
import SwiftUI
import Intents

//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: XJConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: XJConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: XJConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: XJConfigurationIntent
//}
//
//struct XJWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}

@main
struct MainWidget: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        //XJNetWorkPicture(title: "NetWorkPicture", desc: "NetWorkPicture desc")
        XJAppData(title: "XJAppData", desc: "XJAppData desc")
    }
}

//struct XJWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        XJWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: XJConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
