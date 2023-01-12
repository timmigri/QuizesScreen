import SwiftUI

struct FillGapsItem {
    enum Kind {
        case Text, TextField, EndParagraph
    }
    
    let id: Int
    let type: Kind
    let key: String?
    // Text -> text, TextField -> current text field value, EndParagraph -> ""
    var value: String
    
    // Only for TextField
    var isCorrect: Bool? = nil
    var isDisabled: Bool = false
    var color: Color {
        if isCorrect == nil { return .gray }
        if (isCorrect!) { return .green }
        return .red
    }
    // for TextField animation
    var attempts: Int = 0
}

func convertTextToFillGapsItems(_ text: String) -> [FillGapsItem]{
    var items = [FillGapsItem]()
    var idCounter = 1
    func splitStringToWordItems(_ str: String) {
        for word in str.components(separatedBy: " ") {
            items.append(FillGapsItem(id: idCounter, type: .Text, key: nil, value: word))
            idCounter += 1
        }
    }
    for str in text.components(separatedBy: "\n") {
        var cur = ""
        for char in str {
            if (char == "{") {
                splitStringToWordItems(cur)
                cur = ""
            } else if (char == "}") {
                items.append(FillGapsItem(id: idCounter, type: .TextField, key: cur, value: ""))
                cur = ""
                idCounter += 1
            } else {
                cur.append(char)
            }
        }
        if (cur.count > 0) {
            splitStringToWordItems(cur)
        }
        items.append(FillGapsItem(id: idCounter , type: .EndParagraph, key: nil, value: ""))
        idCounter += 1
    }
    let _ = items.popLast()
    return items
}

func renderFillGapsItems(_ items: Binding<[FillGapsItem]>, geometry screenGeometry: GeometryProxy, lastItemId: Int) -> some View {
    var xAligment: CGFloat = .zero
    var yAligment: CGFloat = .zero
    return ZStack(alignment: .topTrailing) {
        ForEach(items, id: \.id) { $item in
            Group {
                if (item.type == .TextField) {
                    TextField("", text: $item.value)
                        .frame(width: 100)
                        .foregroundColor(item.color)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .disabled(item.isDisabled)
                        .overlay(Divider().overlay(item.color), alignment: .bottom)
                        .modifier(Shake(animatableData: CGFloat(item.attempts)))

                } else if (item.type == .Text) {
                    Text(item.value)
                        .offset(y: 5)
                        .padding(.horizontal, 2.5)
                } else if (item.type == .EndParagraph) {
                    Color.clear.frame(height: 20)
                }
            }
            .padding(.vertical, 7)
            .alignmentGuide(.trailing) { d in
                if (abs(xAligment - d.width - 2 * GlobalConstants.quizesWidgetPadding) > screenGeometry.size.width) {
                    xAligment = 0
                    yAligment -= d.height
                }
                let res = xAligment
                if (lastItemId == item.id) {
                    xAligment = 0
                } else {
                    xAligment -= d.width
                }
                return res
            }
            .alignmentGuide(.top) { d in
                let res = yAligment
                if (lastItemId == item.id) {
                    yAligment = 0
                }
                return res
            }
        }
    }
}