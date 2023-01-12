import SwiftUI

struct FillGapsWithChoicesQuestionView: View {
    let question: QuizesModel.FillGapsWithChoicesQuestion
    let screenGeometry: GeometryProxy
    
    @State private var items: [FillGapsItem] = []
    @State private var choices: [QuizesModel.FillGapsWithChoicesQuestion.Choice] = []
    @State private var isFinished: Bool = false
    @State private var areChoicesVisible = true
    
    init(question: QuizesModel.FillGapsWithChoicesQuestion, screenGeometry: GeometryProxy) {
        self.question = question
        self.screenGeometry = screenGeometry
        _items = State(
            initialValue: convertTextToFillGapsItems(question.text).map{ item in
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
                renderFillGapsItems($items, geometry: screenGeometry, lastItemId: items.last!.id)
            }
            if (choices.count > 0) {
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
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.black, lineWidth: 1.5))
                        .padding(.horizontal, 5)
                }
            }
        }.padding(.top, 20)
    }
    
//    private var actionButtons: some View {
//         HStack {
//            Button("Проверить", action: check)
//                .foregroundColor(.blue)
//                .padding(.vertical, 7)
//                .padding(.horizontal, 15)
//                .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
//                .padding(.top, 15)
//                .scaleEffect(isFinished ? 0 : 1)
//
//
//            Button("Ответы", action: showAnswers)
//                .foregroundColor(.blue)
//                .padding(.vertical, 7)
//                .padding(.horizontal, 15)
//                .overlay(RoundedRectangle(cornerRadius: 7).stroke(.blue))
//                .padding(.top, 15)
//                .scaleEffect(isFinished ? 0 : 1)
//        }
//    }
}

struct FillGapsWithChoicesQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = QuizesModel.FillGapsWithChoicesQuestion(
            id: 1,
            title: "Title",
            counterCurrent: 1,
            counterAll: 1,
            text: "Заполните{key1}пропуски{key2}\nс выбором{key3}",
            choices: [
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 1, title: "abc", forKey: "key2"),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 2, title: "abcd", forKey: nil),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 3, title: "abce", forKey: nil),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 4, title: "abca", forKey: "key1"),
                QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 5, title: "abcds", forKey: "key3")
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
