import SwiftUI

struct MatchQuestionView: View {
    let question: QuizesModel.MatchQuestion
    let screenGeometry: GeometryProxy
    
    @State private var firstWords: [String]
    @State private var secondWords: [String]
    @State private var firstWordsSelectedIndex: Int? = nil
    @State private var secondWordsSelectedIndex: Int? = nil
    @State private var isMatchCorrect: Bool? = nil
    @State private var wordMaxWidth: CGFloat?
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private var isFinished: Bool {
        return firstWords.count == 0 && secondWords.count == 0
    }
    
    init(question: QuizesModel.MatchQuestion, screenGeometry: GeometryProxy) {
        self.question = question
        self.screenGeometry = screenGeometry
        _firstWords = State(initialValue: question.pairs.map{ key, value in key }.shuffled())
        _secondWords = State(initialValue: question.pairs.map{ key, value in value }.shuffled())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionHeadView(question: question)
            ZStack {
                HStack(spacing: Constants.spaceBetweenColumns) {
                    firstColumn
                    secondColumn
                }
                .onPreferenceChange(WordWidthPreferenceKey.self) {
                    wordMaxWidth = $0
                }
                wrongSelectionIcon
                doneIcon
            }
        }
        .padding(GlobalConstants.quizesWidgetPadding)
    }
    
    private var firstColumn: some View {
        VStack {
            ForEach(Array(firstWords.enumerated()), id: \.element) { (index, word) in
                renderWord(word: word, isSelected: index == firstWordsSelectedIndex) {
                    withAnimation(.easeOut(duration: Constants.Word.highlightAnimationTime)){
                        firstWordsSelectedIndex = (index != firstWordsSelectedIndex ? index : nil)
                    }
                    checkSelection()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var secondColumn: some View {
        VStack {
            ForEach(Array(secondWords.enumerated()), id: \.element) { (index, word) in
                renderWord(word: word, isSelected: index == secondWordsSelectedIndex) {
                    withAnimation(.easeOut(duration: Constants.Word.highlightAnimationTime)){
                        secondWordsSelectedIndex = (index != secondWordsSelectedIndex ? index : nil)
                    }
                    checkSelection()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func clearSelection() {
        firstWordsSelectedIndex = nil
        secondWordsSelectedIndex = nil
        isMatchCorrect = nil
    }
    
    private func checkSelection() {
        if let firstIndex = firstWordsSelectedIndex, let secondIndex = secondWordsSelectedIndex {
            let firstWord = firstWords[firstIndex]
            let secondWord = secondWords[secondIndex]
            if (question.pairs[firstWord] == secondWord) {
                withAnimation(.easeOut(duration: Constants.Animation.changingMatchCorrect)) {
                    isMatchCorrect = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.correctDelay) {
                    withAnimation(.easeInOut(duration: Constants.Animation.removeWords)) {
                        clearSelection()
                        firstWords.remove(at: firstIndex)
                        secondWords.remove(at: secondIndex)
                    }
                }
            } else {
                withAnimation(.easeOut(duration: Constants.Animation.changingMatchCorrect)) {
                    isMatchCorrect = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.wrongDelay) {
                    clearSelection()
                }
            }
        }
    }
    
    private func getWordColor(isSelected: Bool) -> Color {
        if (!isSelected) {
            return colorScheme == .light ? .black : .white
        }
        if let isCorrect = isMatchCorrect {
            if (isCorrect) {
                return .green
            }
            return .red
        }
        return .orange
    }
    
    private var wrongSelectionIcon : some View {
        var opacity: CGFloat = 0
        if let isCorrect = isMatchCorrect {
            if (!isCorrect) { opacity = 1 }
        }
        return Image(systemName: "xmark")
            .font(.system(size: Constants.WrongIcon.fontSize))
            .foregroundColor(Constants.WrongIcon.color)
            .opacity(opacity)
            .animation(.easeInOut(duration: Constants.WrongIcon.animationTime))
    }
    
    private var doneIcon : some View {
        let to: CGFloat = isFinished ? 1 : 0
        let opacity: CGFloat = isFinished ? 1 : 0
        return Image(systemName: "checkmark")
            .font(.system(size: Constants.DoneIcon.fontSize))
            .padding(Constants.DoneIcon.padding)
            .foregroundColor(Constants.DoneIcon.color)
            .overlay(
                Circle()
                    .trim(from: 0, to: to)
                    .stroke(Constants.DoneIcon.color, lineWidth: Constants.DoneIcon.borderWidth)
                    .rotationEffect(.degrees(180))
            )
            .opacity(opacity)
            .animation(.easeInOut(duration: Constants.DoneIcon.animationTime))
    }
    
    private func renderWord(word: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        let color = getWordColor(isSelected: isSelected)
        let scale = isSelected ? Constants.Word.selectedScale : 1
        let maxColumnWidth = (screenGeometry.size.width - Constants.spaceBetweenColumns) / 2
        return Text(word)
            .lineLimit(1)
            .foregroundColor(color)
            .font(.system(size: Constants.Word.fontSize))
            .padding(Constants.Word.innerPadding)
            .frame(width: wordMaxWidth)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Word.cornerRadius)
                    .stroke(color, lineWidth: Constants.Word.borderWidth)
            )
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: WordWidthPreferenceKey.self,
                        value: min(geometry.size.width, maxColumnWidth)
                    )
                }
            )
            .scaleEffect(scale)
            .padding(.vertical, Constants.Word.outerPadding)
            .onTapGesture {
                if (isMatchCorrect == nil) {
                    onTap()
                }
            }
    }
    
    private struct Constants {
        static let spaceBetweenColumns: CGFloat = 50
        struct Word {
            static let fontSize: CGFloat = 18
            static let innerPadding: CGFloat = 10
            static let cornerRadius: CGFloat = 20
            static let borderWidth: CGFloat = 1.5
            static let outerPadding: CGFloat = 3
            static let selectedScale: CGFloat = 1.05
            static let highlightAnimationTime: CGFloat = 0.1
        }
        struct WrongIcon {
            static let color: Color = .red
            static let fontSize: CGFloat = 50
            static let animationTime: CGFloat = 0.3
        }
        struct DoneIcon {
            static let color: Color = .green
            static let fontSize: CGFloat = 60
            static let borderWidth: CGFloat = 2
            static let padding: CGFloat = 20
            static let animationTime: CGFloat = 1

        }
        struct Animation {
            static let changingMatchCorrect: CGFloat = 0.1
            static let correctDelay: CGFloat = 0.5
            static let wrongDelay: CGFloat = 1
            static let removeWords: CGFloat = 0.3
        }
    }
}

struct MatchQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = QuizesModel.MatchQuestion(
            id: 4,
            title: "Установите соответствие между английскими и русскими словами",
            counterCurrent: 1,
            counterAll: 1,
            pairs: ["shop": "магазин", "magazine": "журнал", "future": "будущее", "mood": "настроение"]
        )
        
        return Group {
            GeometryReader { geometry in
                MatchQuestionView(question: question, screenGeometry: geometry)
            }
            GeometryReader { geometry in
                MatchQuestionView(question: question, screenGeometry: geometry)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
