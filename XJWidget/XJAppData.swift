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
        XJAppDataEntry(date: Date(), configuration: XJAppDataIntent(), displaySize: context.displaySize)
    }

    // 定义Widget预览中如何展示，所以提供默认值要在这里
    func getSnapshot(for configuration: XJAppDataIntent, in context: Context, completion: @escaping (XJAppDataEntry) -> ()) {
        let entry = XJAppDataEntry(date: Date(), configuration: configuration, displaySize: context.displaySize)
        completion(entry)
    }

    // 决定 Widget 何时刷新
    func getTimeline(for configuration: XJAppDataIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [XJAppDataEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = XJAppDataEntry(date: entryDate, configuration: configuration, displaySize: context.displaySize)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct XJAppDataEntry: TimelineEntry {
    let date: Date
    let configuration: XJAppDataIntent
    let displaySize: CGSize
}

struct XJAppDataEntryView : View {
    var entry: XJAppDataProvider.Entry

    var body: some View {
        
        VStack() {

            HStack(alignment: .center, spacing: 20) {
                Link(destination: URL(string: "https://www.baidu.com?str=home")!) {
                    VStack(alignment: .center, spacing: 10) {
                        Image("tab_icon_home_normal")
                            .frame(width: 40, height: 40)
                        Text("扫一扫").font(.caption)
                            .frame(width: 60, height: 20)
                    }
                }
                
                Link(destination: URL(string: "https://www.baidu.com?str=heart")!) {
                    VStack(alignment: .center, spacing: 10) {
                        Image("tab_icon_heart_normal")
                            .frame(width: 40, height: 40)
                            
                        Text("心形灯").font(.caption)
                            .frame(width: 60, height: 20)
                    }
                }
                
                Link(destination: URL(string: "https://www.baidu.com?str=mine")!) {
                    VStack(alignment: .center, spacing: 10) {
                        Image("tab_icon_mine_normal")
                            .frame(width: 40, height: 40)
                        Text("我的").font(.caption)
                            .frame(width: 60, height: 20)
                    }
                }
                
            }
//            .frame(width: entry.displaySize.width, height: entry.displaySize.height - 40)
//            .background(Color.orange)
        }
        
        
        

//        VStack {
//            Text(entry.date, style: .time)
//            Spacer()
//            // 点击交互
//            HStack {
//                Link(destination: URL(string: "https://www.baidu.com?str=left")!) {
//                    // 左 View
//                    leftView()
//                }
//                Spacer()
//                    .frame(width: 20)
//
//                // 右 View
//                Text("right")
//                .widgetURL(URL(string: "https://www.baidu.com?str=right"))
//
//            }
//        }
    }
}

struct leftView : View {

    var body: some View {
        
        HStack {
            
            Text("Left")
        }
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
        .supportedFamilies([.systemMedium])
    }
}
