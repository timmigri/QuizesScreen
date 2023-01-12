import SwiftUI

struct ChoicesQuestionView: View {
    let question: QuizesModel.ChoicesQuestion
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var selectedAnswer: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionHeadView(question: question)
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
        let cornerRadius = CGFloat(5)
        let coef = isFinished ? CGFloat(percent) / 100 : 0
        return GeometryReader { geometry in
            HStack(spacing: 0){
                Rectangle().fill(Constants.Answer.finishedBackgroundColor(colorScheme)).frame(width: coef * geometry.size.width).cornerRadius(cornerRadius, corners: [.topLeft, .bottomLeft]).opacity(opacity)
                Rectangle().fill(Constants.Answer.backgroundColor(colorScheme)).cornerRadius(cornerRadius, corners: [.topRight, .bottomRight]).opacity(opacity)
            }
        }
    }
    
    private struct Constants {
        static let finishedOpacity: CGFloat = 0.65
        struct Counter{
            static let color = Color.gray
        }
        struct Answer {
            static func backgroundColor(_ colorScheme: ColorScheme) -> Color {
                let light = "#e4ebf5"
                let dark = "#1e2530"
                return hexStringToUIColor(hex: (colorScheme == .light ? light : dark))
            }
            static func finishedBackgroundColor(_ colorScheme: ColorScheme) -> Color {
                let light = "#d0dff5"
                let dark = "#010f24"
                return hexStringToUIColor(hex: (colorScheme == .light ? light : dark))
            }
        }
    }
}

struct ChoicesQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = QuizesModel.ChoicesQuestion(id: 1, title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", counterCurrent: 1, counterAll: 1, rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём", 15)])
        return Group {
            ChoicesQuestionView(question: question)
            ChoicesQuestionView(question: question).preferredColorScheme(.dark)
        }
    }
}
