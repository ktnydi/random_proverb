import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), proverb: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let proverbs = fetchProverb()
        let entry = SimpleEntry(date: Date(), proverb: proverbs.first)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let proverbs = fetchProverb()
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, proverb: proverbs.shuffled().first!)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func fetchProverb() -> Array<Proverb> {
        guard let url = Bundle.main.url(forResource: "ProverbData", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let array = json as! [Any]
            let proverbs = array.map { item in
                let dictionary = item as! [String: Any]
                return Proverb(json: dictionary)
            }
            
            return proverbs
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let proverb: Proverb?
}

struct FavoriteWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 4) {
            if let proverb = entry.proverb {
                Text(proverb.message)
                    .multilineTextAlignment(.center)
                Text(proverb.character)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct FavoriteWidget: Widget {
    let kind: String = "FavoriteWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FavoriteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("名言をチェック")
        .description("ランダムで自動表示される名言をチェックできます。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct FavoriteWidget_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                proverb: Proverb(
                    character: "プーさん",
                    message: "何もしないことが、最高の何かを生むことがあるんだよ。",
                    movie: "プーと大人になった僕",
                    year: 2018
                )
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
