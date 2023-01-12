import SwiftUI

struct FillGapsQuestionView: View {
    let question: QuizesModel.FillGapsQuestion
    let screenGeometry: GeometryProxy
    
    @State private var items: [FillGapsItem] = []
    @State private var isFinished: Bool = false
    
    init(question: QuizesModel.FillGapsQuestion, screenGeometry: GeometryProxy) {
        self.question = question
        self.screenGeometry = screenGeometry
        _items = State(initialValue: convertTextToFillGapsItems(question.text))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionHeadView(question: question)
            if (items.count > 0) {
                renderItems()
                HStack {
                    Button("Проверить", action: check)
                    .foregroundColor(.blue)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 15)
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
                    .padding(.top, 15)
                    .scaleEffect(isFinished ? 0 : 1)
        
                    Button("Ответы", action: showAnswers)
                    .foregroundColor(.blue)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 15)
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
                    .padding(.top, 15)
                    .scaleEffect(isFinished ? 0 : 1)
                }
            }
        }.padding(15)
    }
    
    func renderItems() -> some View {
        var xAligment: CGFloat = .zero
        var yAligment: CGFloat = .zero
        var itemsHeight: CGFloat = 0
        var checkButtonWidth: CGFloat = 0
        return ZStack(alignment: .topLeading) {
            ForEach($items, id: \.id) { $item in
                Group {
                    if (item.isTextField) {
                        TextField("", text: $item.value)
                            .frame(width: 100)
                            .foregroundColor(item.color)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .disabled(item.isDisabled)
                            .overlay(Divider().overlay(item.color), alignment: .bottom)
                            .modifier(Shake(animatableData: CGFloat(item.attempts)))
                            .padding(.horizontal, 5)
                            

                    } else {
                        Text(item.value)
                            .offset(y: 5)
                            .padding(.horizontal, 5)
                    }
                }
                .padding(.vertical, 7)
                .alignmentGuide(.leading) { d in
                    if (abs(xAligment - d.width - 2 * 5) > screenGeometry.size.width) {
                        xAligment = 0
                        yAligment -= d.height
                    }
                    let res = xAligment
                    if (items.last!.id == item.id) {
                        xAligment = 0
                    } else {
                        xAligment -= d.width
                    }
                    return res
                }
                .alignmentGuide(.top) { d in
                    let res = yAligment
                    if (items.last!.id == item.id) {
                        itemsHeight = -res + d.height
                        yAligment = 0
                    }
                    return res
                }
            }
            
//            Button("Проверить", action: check)
//            .foregroundColor(.blue)
//            .padding(.vertical, 7)
//            .padding(.horizontal, 15)
//            .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
//            .padding(.top, 15)
//            .scaleEffect(isFinished ? 0 : 1)
//            .alignmentGuide(.leading) { d in
//                checkButtonWidth = d.width
//                return 0
//            }
//            .alignmentGuide(.top) { d in
//                return -itemsHeight
//            }
//
//            Button("Ответы", action: showAnswers)
//            .foregroundColor(.blue)
//            .padding(.vertical, 7)
//            .padding(.horizontal, 15)
//            .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
//            .padding(.top, 15)
//            .scaleEffect(isFinished ? 0 : 1)
//            .alignmentGuide(.leading) { d in
//                return -checkButtonWidth - 20
//            }
//            .alignmentGuide(.top) { d in
//                return -itemsHeight
//            }
        }.border(.red).frame(maxWidth: .infinity)
    }
    
    private func check() {
        var wrongUserAnswers = 0
        for index in items.indices {
            let item = items[index]
            if (!item.isTextField) { continue }
            if let answer = question.answers[item.key!] {
                let isCorrect = (item.value == answer)
                if (isCorrect) {
                    items[index].isDisabled = true
                    withAnimation(.easeInOut(duration: 0.1)) {
                        items[index].isCorrect = isCorrect
                    }
                }
                else {
                    wrongUserAnswers += 1
                    withAnimation(.easeInOut(duration: 0.5)) {
                        items[index].isCorrect = isCorrect
                        items[index].attempts += 1
                    }
                }
            }
        }
        if (wrongUserAnswers == 0) {
            withAnimation {
                isFinished = true
            }
        }
    }
    
    private func showAnswers() {
        for index in items.indices {
            let item = items[index]
            if (!item.isTextField) { continue }
            if (item.isCorrect ?? false) { continue }
            if let answer = question.answers[item.key!] {
                items[index].isCorrect = false
                items[index].value = answer
            }
        }
        withAnimation {
            isFinished = true
        }
    }
}

struct FillGapsQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let text = "Заполните{key1}пропуски{key2}в тексте{key3}Какой-то текст дальше..."
        let answers: [String:String] = ["key1": "abc", "key2": "kek", "key3": "lol"]
        let question = QuizesModel.FillGapsQuestion(id: 1, title: "Заполните пропуски", counterCurrent: nil, counterAll: nil, text: text, answers: answers)
        
        return Group {
            GeometryReader { geometry in
                FillGapsQuestionView(question: question, screenGeometry: geometry)
            }
            GeometryReader { geometry in
                FillGapsQuestionView(question: question, screenGeometry: geometry)
                    .preferredColorScheme(.dark)
            }
        }
    }
}

