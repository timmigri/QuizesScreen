import SwiftUI

struct FillGapsQuestionView: View {
    let question: QuizesModel.FillGapsQuestion
    let screenGeometry: GeometryProxy
    
    @State private var items: [FillGapsItem] = []
    @State private var isFinished: Bool = false
    @State private var areButtonsVisible = true
    
    init(question: QuizesModel.FillGapsQuestion, screenGeometry: GeometryProxy) {
        self.question = question
        self.screenGeometry = screenGeometry
        _items = State(initialValue: convertTextToFillGapsItems(question.text))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionHeadView(question: question)
            if (items.count > 0) {
                renderFillGapsItems($items, geometry: screenGeometry, lastItemId: items.last!.id)
                if (areButtonsVisible) {
                    actionButtons
                }
            }
        }
        .padding(GlobalConstants.quizesWidgetPadding)
    }
    
    private var actionButtons: some View {
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
    
    private func check() {
        if (isFinished) { return }
        
        var wrongUserAnswers = 0
        for index in items.indices {
            let item = items[index]
            if (item.type != .TextField) { continue }
            if let answer = question.answers[item.key!] {
                let isCorrect = (item.value.lowercased() == answer.lowercased())
                if (isCorrect) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        items[index].value = answer
                        items[index].isCorrect = isCorrect
                        items[index].isDisabled = true
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
            finish()
        }
    }
    
    private func showAnswers() {
        if (!isFinished) { finish() }
    }
    
    private func finish() {
        withAnimation {
            for index in items.indices {
                let item = items[index]
                if (item.type != .TextField) { continue }
                if (item.isCorrect ?? false) { continue }
                if let answer = question.answers[item.key!] {
                    items[index].isCorrect = false
                    items[index].isDisabled = true
                    items[index].value = answer
                }
            }
            isFinished = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            areButtonsVisible = false
        }
    }
}

struct FillGapsQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let text = "\"Джентельмены\" - криминальная комедия режиссёра Гая {key1} по собственному сценарию. Главные роли в фильме исполняют Чарли Ханнэм, Генри Голдинг, Мишель Докери, Колин Фаррелл, Хью Грант и Мэттью {key2}. Бюджет фильма составил ${key3} млн\n{key4} Вильгельм Ди Каприо - американский актёр и продюсер, родился 11 ноября {key5} в Лос-Анджелесе, США. Всемирная известность обрушилась на актёра благодаря главной роли в фильме-катастрофе \"{key6}\". Первый и пока свой единственный «Оскар» ДиКаприо получил в 2016 году за роль в драме \"{key7}\""
        let answers: [String:String] = ["key1": "Ричи", "key2": "Макконахи", "key3": "22", "key4": "Леонардо", "key5": "1974", "key6": "Титаник", "key7": "Выживший"]
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

