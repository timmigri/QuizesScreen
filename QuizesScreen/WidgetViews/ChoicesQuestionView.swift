import SwiftUI

struct ChoicesQuestionView: View {
    @State var selectedAnswer: String? = nil
    let question: QuizesModel.ChoicesQuestion
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionHeadView(title: question.title, numberCurrent: question.numberCurrent, numberAll: question.numberAll)
            ForEach(question.answers, id: \.self.0) { (answer, percent) in
                HStack(alignment: .center, spacing: 5) {
                    Text(answer)
                        .opacity(calcOpacity(answer: answer))
                    Spacer()
                    if (question.rightAnswer == answer) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(calcOpacity(answer: answer, inverted: true))
                    } else {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(calcOpacity(answer: answer, inverted: true))
                    }
                    Text("\(percent)%")
                        .font(.body.weight(.medium))
                        .opacity(calcOpacity(answer: answer, inverted: true))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(answerBackground(percent: percent, opacity: calcOpacity(answer: answer)))
                .onTapGesture {
                    if (selectedAnswer == nil) {
                        withAnimation {
                            selectedAnswer = answer
                        }
                    }
                }
            }
        }.padding(15)
    }
    
    func calcOpacity(answer: String, inverted: Bool = false) -> CGFloat {
        let defaultOpacity: CGFloat = inverted ? 0 : 1
        let finishedOpacity: CGFloat = selectedAnswer == answer ? 1 : Constants.finishedOpacity
        return isFinished ? finishedOpacity : defaultOpacity
    }
    
    var isFinished: Bool {
        selectedAnswer != nil
    }
    
    func answerBackground(percent: Int, opacity: CGFloat) -> some View {
        let color = colorScheme == .light ? Constants.Answer.backgroundColor : Constants.Answer.darkModeBackgroundColor
        let finishedColor = colorScheme == .light ? Constants.Answer.finishedBackgroundColor : Constants.Answer.darkModeFinishedBackgroundColor
        let cornerRadius = CGFloat(5)
        let coef = isFinished ? CGFloat(percent) / 100 : 0
        return GeometryReader { geometry in
            HStack(spacing: 0){
                Rectangle().fill(finishedColor).frame(width: coef * geometry.size.width).cornerRadius(cornerRadius, corners: [.topLeft, .bottomLeft]).opacity(opacity)
                Rectangle().fill(color).cornerRadius(cornerRadius, corners: [.topRight, .bottomRight]).opacity(opacity)
            }
        }
    }
    
    private struct Constants {
        static let finishedOpacity: CGFloat = 0.65
        struct Counter{
            static let color = Color.gray
        }
        struct Answer {
            static let backgroundColor = hexStringToUIColor(hex: "#e4ebf5")
            static let finishedBackgroundColor = hexStringToUIColor(hex: "#d0dff5")
            static let darkModeBackgroundColor = hexStringToUIColor(hex: "#1e2530")
            static let darkModeFinishedBackgroundColor = hexStringToUIColor(hex: "#010f24")
        }
    }
}

struct ChoicesQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        ChoicesQuestionView(question: QuizesModel.ChoicesQuestion(id: 1, title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", numberCurrent: 1, numberAll: 1, rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём", 15)]))
        ChoicesQuestionView(question: QuizesModel.ChoicesQuestion(id: 1, title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", numberCurrent: 1, numberAll: 1, rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём", 15)])).preferredColorScheme(.dark)
    }
}
