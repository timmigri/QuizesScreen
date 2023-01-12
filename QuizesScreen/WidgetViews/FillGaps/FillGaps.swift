import SwiftUI

struct FillGapsItem {
    let id: Int
    // if key is nil -> Text, otherwise -> TextField
    let key: String?
    // Text -> text, TextField -> current text field value
    var value: String
    
    var isTextField: Bool {
        return key != nil
    }
    
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
    var cur = ""
    var counter = 0
    for char in text {
        if (char == "{") {
            items.append(FillGapsItem(id: counter, key: nil, value: cur))
            cur = ""
            counter += 1
        } else if (char == "}") {
            items.append(FillGapsItem(id: counter, key: cur, value: ""))
            cur = ""
            counter += 1
        } else {
            cur.append(char)
        }
    }
    if (cur.count > 0) {
        items.append(FillGapsItem(id: counter, key: nil, value: cur))
    }
    return items
}
