import SwiftUI

struct FillGapsQuestionView: View {
    enum Item : Hashable {
        static func == (lhs: FillGapsQuestionView.Item, rhs: FillGapsQuestionView.Item) -> Bool {
            return false
        }
        
        case text(id: Int, text: String)
        case input(id: Int, content: InputField)
        
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
        
        var content: String {
            get {
                switch self {
                case .text(_, let text):
                    return text
                case .input(_, let content):
                    return content.value
                }
            }
            set {
                switch self {
                case .text(let id, let text):
                    self = .text(id: id, text: newValue)
                case .input(let id, let content):
                    self = .input(id: id, content: InputField(key: content.key, value: newValue))
                }
            }
        }
    }
    
    struct InputField {
        var key: String
        var value: String = ""
    }
    
    let text = "Заполните{key1}пропуски{key2}в тексте{key3}Какой-то текст дальше..."
    @State var value = ""
    @State var textFieldValues: [String:String] = [:]
    @State var items: [Item] = []
    @State var bruh: [Blah] = []
    
    init() {
        _bruh = State(initialValue: parseText())
        _textFieldValues = State(initialValue: ["key1": "", "key2": "", "key3": ""])
    }
    
    var body: some View {
        GeometryReader { geometry in
            if (bruh.count > 0) {
                renderItems(geometry: geometry)
                
            }
        }.padding(15)
    }
    
    struct Blah {
        let key: String?
        var value: String
    }
    
    func renderItems(geometry: GeometryProxy) -> some View {
        var xAligment: CGFloat = .zero
        var yAligment: CGFloat = .zero
        var heightOfItems: CGFloat = 0
        // top Leading ZTAck
        return VStack(alignment: .leading) {
            Button("Проверить") {
                
            }
            .foregroundColor(.blue)
            .padding(.vertical, 7)
            .padding(.horizontal, 15)
            .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
            .padding(.top, 15)
            .alignmentGuide(.top) { d in
                return -heightOfItems
            }
            ForEach($bruh, id: \.key) { $bruo in
                Group {
//                    switch item {
//                    case .text(_, let text):
//                        Text(text)
//                            .offset(y: 5)
//                            .padding(.horizontal, 5)
//                    case .input(_, let key):
//                        TextField("", text: $item.content)
//                            .frame(width: 100)
//                            .overlay(Divider(), alignment: .bottom)
//                            .padding(.horizontal, 5)
//                    }
                    Text("Fg")
                    TextField("", text: $bruo.value).frame(width: 100)
                }
                .padding(.vertical, 7)
//                .alignmentGuide(.leading) { d in
//                    if (abs(xAligment - d.width - 2 * 5) > geometry.size.width) {
//                        xAligment = 0
//                        yAligment -= d.height
//                    }
//                    let res = xAligment
//                    if (items.last!.getId() == item.getId()) {
//                        xAligment = 0
//                    } else {
//                        xAligment -= d.width
//                    }
//                    return res
//                }
//                .alignmentGuide(.top) { d in
//                    let res = yAligment
//                    if (items.last!.getId() == item.getId()) {
//                        heightOfItems = -res + d.height
//                        yAligment = 0
//                    }
//                    return res
//                }
            }
        }
    }
    
    private func parseText() -> [Blah]{
        var items = [Item]()
        var bruh = [Blah]()
        var cur = ""
        var counter = 0
        for char in text {
            if (char == "{") {
                items.append(.text(id: counter, text: cur))
                cur = ""
                counter += 1
                bruh.append(Blah(key: nil, value: ""))
            } else if (char == "}") {
                items.append(.input(id: counter, content: InputField(key: cur)))
                bruh.append(Blah(key: cur, value: ""))
                cur = ""
                counter += 1
            } else {
                cur.append(char)
            }
        }
        if (cur.count > 0) {
            items.append(.text(id: counter, text: cur))
        }
        return bruh
    }
}

struct FillGapsQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        FillGapsQuestionView()
    }
}

