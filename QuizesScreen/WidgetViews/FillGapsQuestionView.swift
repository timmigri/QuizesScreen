import SwiftUI

struct FillGapsQuestionView: View {
    enum Item : Hashable {
        case text(id: Int, text: String)
        case input(id: Int, key: String)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .text(let id, _):
                hasher.combine(id)
            case .input(let id, _):
                hasher.combine(id)
            }
        }
        
        func getId() -> Int{
            switch self {
            case .text(let id, _):
                return id
            case .input(let id, _):
                return id
            }
        }
    }
    let text = "Заполните{key1}пропуски{key2}\n{key3}Какой-то текст дальше..."
    @State var value = ""
    @State var textFieldValues: [String: String] = ["key1":"123", "key2": "1", "key3":"abc"]
    @State var xAligment: CGFloat = .zero
    @State var yAligment: CGFloat = .zero
    @State var items: [Item] = []
    
    init() {
        _items = State(initialValue: parseText())
    }
    
    var body: some View {
        GeometryReader { geometry in
            if (items.count > 0) {
                ZStack(alignment: .topLeading) {
                    renderItems(geometry: geometry)
//                    .alignmentGuide(.leading) { d in
//                        if (abs(xAligment - d.width - 2 * 5) > geometry.size.width) {
//                            xAligment = 0
//                            yAligment -= d.height
//                        }
//                        let res = xAligment
//                        if (items.last!.getId() == item.getId()) {
//                            xAligment = 0
//                        } else {
//                            xAligment -= d.width
//                        }
//                        return res
//                    }
//                    .alignmentGuide(.top) { d in
//                        let res = yAligment
//                        if (items.last!.getId() == item.getId()) {
//                            yAligment = 0
//                        }
//                        return res
//                    }
                }
            }
        }.padding(15)
    }
    
    func renderItems(geometry: GeometryProxy) -> some View {
        return ForEach(items, id: \.self) { item in
            Group {
                switch item {
                case .text(_, let text):
                    Text(text)
                        .alignmentGuide(.leading) { d in
                            if (abs(xAligment - d.width - 2 * 5) > geometry.size.width) {
                                xAligment = 0
                                yAligment -= d.height
                            }
                            let res = xAligment
                            if (items.last!.getId() == item.getId()) {
                                xAligment = 0
                            } else {
                                xAligment -= d.width
                            }
                            print(d.width, geometry.size.width)
                            return res
                        }
                        .alignmentGuide(.top) { d in
                            let res = yAligment
                            if (items.last!.getId() == item.getId()) {
                                yAligment = 0
                            }
                            return res
                        }
                case .input(_, let key):
                    TextField("", text: $value)
                        .overlay(Divider().offset(y: 3), alignment: .bottom)
                        .onChange(of: value) {
                            textFieldValues[key] = $0
                        }
                }
            }
        }
    }
    
    func parseText() -> [Item]{
        var items = [Item]()
        var cur = ""
        var counter = 0
        for char in text {
            if (char == "{") {
                items.append(.text(id: counter, text: cur))
                cur = ""
                counter += 1
            } else if (char == "}") {
//                items.append(.input(id: counter, key: cur))
                cur = ""
                counter += 1
            } else {
                cur.append(char)
            }
        }
        if (cur.count > 0) {
            items.append(.text(id: counter, text: cur))
        }
        return items
    }
}

struct FillGapsQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        FillGapsQuestionView()
    }
}
