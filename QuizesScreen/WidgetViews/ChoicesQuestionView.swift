import SwiftUI

struct ChoicesQuestionView: View {
    let question: QuizesModel.ChoicesQuestion
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var selectedAnswerId: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionHeadView(question: question)
            ForEach(question.answers, id: \.self.id) { answer in
                HStack(alignment: .center, spacing: 5) {
                    Text(answer.title)
                        .opacity(calcOpacity(answerId: answer.id))
                    Spacer()
                    if (question.rightAnswerId == answer.id) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(calcOpacity(answerId: answer.id, inverted: true))
                    } else {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(calcOpacity(answerId: answer.id, inverted: true))
                    }
                    Text("\(answer.percent)%")
                        .font(.body.weight(.medium))
                        .opacity(calcOpacity(answerId: answer.id, inverted: true))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    answerBackground(
                        percent: answer.percent,
                        opacity: calcOpacity(answerId: answer.id)
                    )
                )
                .onTapGesture {
                    if (selectedAnswerId == nil) {
                        withAnimation {
                            selectedAnswerId = answer.id
                        }
                    }
                }
            }
        }.padding(GlobalConstants.quizesWidgetPadding)
    }
    
    func calcOpacity(answerId: Int, inverted: Bool = false) -> CGFloat {
        let defaultOpacity: CGFloat = inverted ? 0 : 1
        let finishedOpacity: CGFloat = selectedAnswerId == answerId ? 1 : Constants.finishedOpacity
        return isFinished ? finishedOpacity : defaultOpacity
    }
    
    var isFinished: Bool {
        selectedAnswerId != nil
    }
    
    func answerBackground(percent: Int, opacity: CGFloat) -> some View {
        let coef = isFinished ? CGFloat(percent) / 100 : 0
        return GeometryReader { geometry in
            HStack(spacing: 0){
                Rectangle()
                    .fill(Constants.Answer.finishedBackgroundColor(colorScheme))
                    .frame(width: coef * geometry.size.width)
                    .cornerRadius(
                        Constants.Answer.backgroundCornerRadius,
                        corners: [.topLeft, .bottomLeft])
                    .opacity(opacity)
                Rectangle()
                    .fill(Constants.Answer.backgroundColor(colorScheme))
                    .cornerRadius(
                        Constants.Answer.backgroundCornerRadius,
                        corners: [.topRight, .bottomRight])
                    .opacity(opacity)
            }
        }
    }
    
    private struct Constants {
        static let finishedOpacity: CGFloat = 0.65
        struct Counter{
            static let color = Color.gray
        }
        struct Answer {
            static let backgroundCornerRadius: CGFloat = 5
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
        let question = QuizesModel.ChoicesQuestion(
            id: 1,
            title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?",
            counterCurrent: 1,
            counterAll: 1,
            answers: [
                QuizesModel.ChoicesQuestion.Answer(id: 1, title: "Он научился летать", percent: 13),
                QuizesModel.ChoicesQuestion.Answer(id: 2, title: "Он родился старым и молодел", percent: 60),
                QuizesModel.ChoicesQuestion.Answer(id: 3, title: "Он умел предсказывать будущее", percent: 12),
                QuizesModel.ChoicesQuestion.Answer(id: 4, title: "Он становился больше с каждым днём", percent: 15)
            ],
            rightAnswerId: 1
        )
        return Group {
            ChoicesQuestionView(question: question)
            ChoicesQuestionView(question: question).preferredColorScheme(.dark)
        }
    }
}
