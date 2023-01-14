import SwiftUI

struct FillGapsItem {
    enum Kind {
        case Text, TextField, ChoiceArea, EndParagraph
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

func convertTextToFillGapsItems(_ text: String, areGapsChoices: Bool = false) -> [FillGapsItem]{
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
                items.append(FillGapsItem(id: idCounter, type: (areGapsChoices ? .ChoiceArea : .TextField), key: cur, value: ""))
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

func renderChoiceGapArea(_ item: FillGapsItem, onDrop: @escaping ([NSItemProvider], Int) -> Bool) -> some View {
    var choiceGapAreaOverlay: some View {
        Text(item.value)
            .foregroundColor(item.color)
            .frame(width: Constants.ChoiceAreaText.width)
            .offset(y: Constants.ChoiceAreaText.offsetY)
            .lineLimit(1)
    }
    
    let isDropAvailable = !(item.isCorrect != nil && item.isCorrect!)
    
    return Rectangle()
            .fill(Constants.ChoiceArea.backgroundColor)
            .frame(width: Constants.ChoiceArea.width, height: Constants.ChoiceArea.height)
            .border(item.color)
            .offset(y: Constants.ChoiceArea.offsetY)
            .padding(.horizontal, Constants.ChoiceArea.paddingHorizontal)
            .onDrop(of: (isDropAvailable ? [.plainText] : []), isTargeted: nil) { providers, location in
                return onDrop(providers, item.id)
            }
            .modifier(Shake(animatableData: CGFloat(item.attempts)))
            .overlay((item.isCorrect != nil && item.isCorrect!) ? choiceGapAreaOverlay : nil, alignment: .center)
}

func renderFillGapsItems(_ items: Binding<[FillGapsItem]>, geometry screenGeometry: GeometryProxy, lastItemId: Int, colorScheme: ColorScheme, onDrop: @escaping ([NSItemProvider], Int) -> Bool) -> some View {
    var xAligment: CGFloat = .zero
    var yAligment: CGFloat = .zero
    
    return ZStack(alignment: .topTrailing) {
        ForEach(items, id: \.id) { $item in
            Group {
                if (item.type == .TextField) {
                    TextField("", text: $item.value)
                        .frame(width: Constants.TextField.width)
                        .foregroundColor(item.color)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .disabled(item.isDisabled)
                        .overlay(Divider().foregroundColor(Constants.TextField.dividerColor()), alignment: .bottom)
                        .modifier(Shake(animatableData: CGFloat(item.attempts)))

                } else if (item.type == .Text) {
                    Text(item.value)
                        .offset(y: Constants.Text.offsetY)
                        .padding(.horizontal, Constants.Text.paddingHorizontal)
                } else if (item.type == .EndParagraph) {
                    Color.clear.frame(height: Constants.EndParagraph.height)
                } else if (item.type == .ChoiceArea) {
                    renderChoiceGapArea(item, onDrop: onDrop)
                }
            }
            .padding(.vertical, Constants.itemPaddingVertical)
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


fileprivate struct Constants {
    static let itemPaddingVertical: CGFloat = 7
    struct TextField {
        static let width: CGFloat = 100
        static func dividerColor(_ colorScheme: ColorScheme) -> Color {
            let light: Color = .gray
            let dark = "#ffffff"
            return (colorScheme == .light ? light : hexStringToUIColor(hex: dark)
        }
    }
    struct Text {
        static let offsetY: CGFloat = 5
        static let paddingHorizontal: CGFloat = 2.5
    }
    struct EndParagraph {
        static let height: CGFloat = 20
    }
    struct ChoiceArea {
        static let backgroundColor: Color = .white
        static let width: CGFloat = 100
        static let height: CGFloat = 30
        static let offsetY: CGFloat = -5
        static let paddingHorizontal: CGFloat = 5
    }
    struct ChoiceAreaText {
        static let width: CGFloat = 80
        static let offsetY: CGFloat = -5
    }
}
