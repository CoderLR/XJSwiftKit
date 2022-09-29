//
//  XJNetWorkPicture.swift
//  XJWidgetExtension
//
//  Created by xj on 2022/9/28.
//

import WidgetKit
import SwiftUI
import Intents

struct XJNetWorkPictureProvider: IntentTimelineProvider {
    var img = Image("2")
    func placeholder(in context: Context) -> XJNetWorkPictureEntry {
        XJNetWorkPictureEntry(date: Date(), configuration: XJNetWorkPictureIntent(), displaySize: context.displaySize, img: img)
    }

    // 定义Widget预览中如何展示，所以提供默认值要在这里
    func getSnapshot(for configuration: XJNetWorkPictureIntent, in context: Context, completion: @escaping (XJNetWorkPictureEntry) -> ()) {
        let entry = XJNetWorkPictureEntry(date: Date(), configuration: configuration, displaySize: context.displaySize, img: img)
        completion(entry)
    }

    // 决定 Widget 何时刷新
    func getTimeline(for configuration: XJNetWorkPictureIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
//        var entries: [XJNetWorkPictureEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = XJNetWorkPictureEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
        var img = Image("2")
        // 占位图
        WidgetImageLoader.shareLoader.downLoadImage(imageUrl: "https://img2022.cnblogs.com/blog/775305/202209/775305-20220928112438365-699430803.png") { result in
            
            var entries: [XJNetWorkPictureEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = XJNetWorkPictureEntry(date: entryDate, configuration: configuration, displaySize: context.displaySize,img: img)
                entries.append(entry)
            }
            
            switch result {
            case .success(let image):
                print("成功 = \(image)")
                img = image
                // 每隔2个小时刷新。
                let entry = XJNetWorkPictureEntry(date: Date(), configuration: configuration, displaySize: context.displaySize,img: img)
                entries.append(entry)
                    // refresh the data every two hours
                let expireDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()
                let timeline = Timeline(entries: entries, policy: .after(expireDate))
                
                completion(timeline)
            case .failure(let error):
                print("失败 = \(error)")
            }
        }
    }
}

struct XJNetWorkPictureEntry: TimelineEntry {
    let date: Date
    let configuration: XJNetWorkPictureIntent
    let displaySize: CGSize
    let img: Image
}

struct XJNetWorkPictureEntryView : View {
    var entry: XJNetWorkPictureProvider.Entry

    var body: some View {
        
        ZStack {
            entry.img
                .resizable()
                .frame(width: entry.displaySize.width, height: entry.displaySize.height, alignment: .center)
            
            Text(entry.date, style: .time)
                .font(Font(CTFont(.label, size: 50)))
                .frame(width: entry.displaySize.width, height: entry.displaySize.height,alignment: .center)
                .foregroundColor(.white)
        }
    }
}

//@main
struct XJNetWorkPicture: Widget {
    let kind: String = "XJNetWorkPicture"
    var title: String = ""
    var desc: String = ""

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: XJNetWorkPictureIntent.self, provider: XJNetWorkPictureProvider()) { entry in
            XJNetWorkPictureEntryView(entry: entry)
        }
        .configurationDisplayName(title)
        .description(desc)
        .supportedFamilies([.systemMedium, .systemSmall])
    }
}

//struct XJNetWorkPicture_Previews: PreviewProvider {
//    static var previews: some View {
//        XJNetWorkPictureEntryView(entry: XJNetWorkPictureEntry(date: Date(), configuration: XJNetWorkPictureIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
