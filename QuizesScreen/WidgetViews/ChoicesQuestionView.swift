import SwiftUI

struct ChoicesQuestionView: View {
    let question: QuizesModel.ChoicesQuestion
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Вопрос \(question.numberCurrent)/\(question.numberAll)")
                .foregroundColor(Constants.Counter.color)
                .padding(.bottom, 10)
            Text(question.question)
                .font(.title2)
            ForEach(question.answers, id: \.self.0) { (answer, percent) in
                HStack(alignment: .center, spacing: 5) {
                    Text(answer)
                    Spacer()
                    if (question.rightAnswer == answer) {
                        Image(systemName: "checkmark").foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark").foregroundColor(.red)
                    }
                    Text("\(percent)%").font(.body.weight(.medium))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(answerBackground)
                .padding(.vertical, 3)
            }
        }.padding(15)
    }
    
    var answerBackground : some View {
        let color = colorScheme == .light ? Constants.Answer.backgroundColor : Constants.Answer.darkModeBackgroundColor
        return Rectangle().fill(color).cornerRadius(5)
    }
    
    private struct Constants {
        struct Counter{
            static let color = Color.gray
        }
        struct Answer {
            static let backgroundColor = hexStringToUIColor(hex: "#e4ebf5")
            static let darkModeBackgroundColor = hexStringToUIColor(hex: "#141a24")
        }
    }
}

struct ChoicesQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        ChoicesQuestionView(question: QuizesModel.ChoicesQuestion(numberCurrent: 1, numberAll: 1, question: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём b nfrflsfl", 15)]))
        ChoicesQuestionView(question: QuizesModel.ChoicesQuestion(numberCurrent: 1, numberAll: 1, question: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём b nfrflsfl", 15)])).preferredColorScheme(.dark)
    }
}
