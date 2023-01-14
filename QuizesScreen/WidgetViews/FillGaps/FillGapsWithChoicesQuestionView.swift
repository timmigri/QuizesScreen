import SwiftUI

struct FillGapsWithChoicesQuestionView: View {
    let question: QuizesModel.FillGapsWithChoicesQuestion
    let screenGeometry: GeometryProxy
    
    @State private var items: [FillGapsItem] = []
    @State private var choices: [QuizesModel.FillGapsWithChoicesQuestion.Choice] = []
    @State private var areChoicesVisible = true
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private var isFinished: Bool {
        for item in items {
            if (item.type != .ChoiceArea) { continue }
            guard let isCorrect = item.isCorrect else {
                return false
            }
            if (!isCorrect) { return false }
        }
        return true
    }
    
    init(question: QuizesModel.FillGapsWithChoicesQuestion, screenGeometry: GeometryProxy) {
        self.question = question
        self.screenGeometry = screenGeometry
        _items = State(
            initialValue: convertTextToFillGapsItems(question.text, areGapsChoices: true).map{ item in
                var mutableItem = item
                mutableItem.isDisabled = true
                return mutableItem
            }
        )
        _choices = State(initialValue: question.choices)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionHeadView(question: question)
            if (items.count > 0) {
                renderFillGapsItems($items, geometry: screenGeometry, lastItemId: items.last!.id, onDrop: drop)
            }
            if (choices.count > 0 && !isFinished) {
                choiceButtons
            }
        }
        .padding(GlobalConstants.quizesWidgetPadding)
    }
    
    private var choiceButtons: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(choices, id: \.id) { choice in
                    Text(choice.title)
                        .padding(.vertical, Constants.ChoiceButton.paddingVertical)
                        .padding(.horizontal, Constants.ChoiceButton.paddingHorizontal)
                        .onDrag{
                            return NSItemProvider(object: (choice.title) as NSString)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.ChoiceButton.cornerRadius)
                                .stroke(Constants.ChoiceButton.borderColor(colorScheme), lineWidth: Constants.ChoiceButton.borderWidth))
                        .padding(.horizontal, Constants.ChoiceButton.spaceBetween)
                }
            }
            .padding(.vertical, Constants.choicesInnerPadding)
        }.padding(.top, Constants.choicesPaddingTop)
    }
    
    private func drop(providers: [NSItemProvider], itemId: Int) -> Bool {
        let found = providers.loadObjects(ofType: String.self) { choiceTitle in
            if let index = items.firstIndex(where: { $0.id == itemId }), let choice = choices.first(where: { $0.title == choiceTitle }) {
                if (choice.forKey == items[index].key) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        items[index].isCorrect = true
                        items[index].value = choice.title
                        choices.removeAll(where: { $0.forKey == choice.forKey })
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        items[index].isCorrect = false
                        items[index].attempts += 1
                        items[index].value = choiceTitle
                    }
                }
            }
        }

        return found
    }
    
    private struct Constants {
        static let choicesInnerPadding: CGFloat = 10
        static let choicesPaddingTop: CGFloat = 20
        struct ChoiceButton {
            static let paddingVertical: CGFloat = 5
            static let paddingHorizontal: CGFloat = 10
            static let cornerRadius: CGFloat = 5
            static func borderColor(_ colorScheme: ColorScheme) -> Color {
                colorScheme == .light ? .black : .white
            }
            static let borderWidth: CGFloat = 1.5
            static let spaceBetween: CGFloat = 5
        }
    }
}

struct FillGapsWithChoicesQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = QuizesModel.FillGapsWithChoicesQuestion(
            id: 5,
            title: "Заполните пропуски в тексте о Rammstein",
            counterCurrent: 1,
            counterAll: 1,
            text: "Группа Rammstein была основана в январе {key1} года в {key2} гитаристом Рихардом {key3}. Музыкальный стиль группы относится к жанру {key4}",
            choices: [
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 1, title: "1997", forKey: nil),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 2, title: "Бремене", forKey: nil),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 3, title: "индастриал-метала", forKey: "key4"),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 4, title: "Круспе", forKey: "key3"),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 5, title: "инди-рока", forKey: nil),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 6, title: "Лоренцем", forKey: nil),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 7, title: "Берлине", forKey: "key2"),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 8, title: "1994", forKey: "key1"),
            ]
        )
        return Group {
            GeometryReader { geometry in
                FillGapsWithChoicesQuestionView(question: question, screenGeometry: geometry)
            }
            GeometryReader { geometry in
                FillGapsWithChoicesQuestionView(question: question, screenGeometry: geometry)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
