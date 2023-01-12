import SwiftUI

struct MatchQuestionView: View {
    let question: QuizesModel.MatchQuestion
    
    @State var firstWords: [String]
    @State var secondWords: [String]
    @State var firstWordsSelectedIndex: Int? = nil
    @State var secondWordsSelectedIndex: Int? = nil
    @State var isMatchCorrect: Bool? = nil
    @State var wordMaxWidth: CGFloat?
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(question: QuizesModel.MatchQuestion) {
        self.question = question
        _firstWords = State(initialValue: question.pairs.map{ key, value in key }.shuffled())
        _secondWords = State(initialValue: question.pairs.map{ key, value in value }.shuffled())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionHeadView(question: question)
            ZStack {
                HStack(spacing: 50) {
                    VStack {
                        ForEach(Array(firstWords.enumerated()), id: \.element) { (index, word) in
                            renderWord(word: word, isSelected: index == firstWordsSelectedIndex) {
                                withAnimation(.easeOut(duration: 0.1)){
                                    firstWordsSelectedIndex = (index != firstWordsSelectedIndex ? index : nil)
                                }
                                checkSelection()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        ForEach(Array(secondWords.enumerated()), id: \.element) { (index, word) in
                            renderWord(word: word, isSelected: index == secondWordsSelectedIndex) {
                                withAnimation(.easeOut(duration: 0.1)){
                                    secondWordsSelectedIndex = (index != secondWordsSelectedIndex ? index : nil)
                                }
                                checkSelection()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
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
    
    func clearSelection() {
        firstWordsSelectedIndex = nil
        secondWordsSelectedIndex = nil
        isMatchCorrect = nil
    }
    
    func checkSelection() {
        if let firstIndex = firstWordsSelectedIndex, let secondIndex = secondWordsSelectedIndex {
            let firstWord = firstWords[firstIndex]
            let secondWord = secondWords[secondIndex]
            if (question.pairs[firstWord] == secondWord) {
                withAnimation(.easeOut(duration: 0.1)) {
                    isMatchCorrect = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        clearSelection()
                        firstWords.remove(at: firstIndex)
                        secondWords.remove(at: secondIndex)
                    }
                }
            } else {
                withAnimation(.easeOut(duration: 0.1)) {
                    isMatchCorrect = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    clearSelection()
                }
            }
        }
    }
    
    func getWordColor(isSelected: Bool) -> Color {
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
    
    var wrongSelectionIcon : some View {
        var opacity: CGFloat = 0
        if let isCorrect = isMatchCorrect {
            if (!isCorrect) { opacity = 1 }
        }
        return Image(systemName: "xmark")
            .font(.system(size: 50))
            .foregroundColor(.red)
            .opacity(opacity)
            .animation(.easeInOut(duration: 0.3))
    }
    
    var isFinished: Bool {
        return firstWords.count == 0 && secondWords.count == 0
    }
    
    var doneIcon : some View {
        let to: CGFloat = isFinished ? 1 : 0
        let opacity: CGFloat = isFinished ? 1 : 0
        return Image(systemName: "checkmark")
            .font(.system(size: 60))
            .padding(20)
            .foregroundColor(.green)
            .overlay(
                Circle().trim(from: 0, to: to).stroke(.green, lineWidth: 2)            .rotationEffect(.degrees(180))
            )
            .opacity(opacity)
            .animation(.easeInOut(duration: 1))
    }
    
    func renderWord(word: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        let color = getWordColor(isSelected: isSelected)
        let scale = isSelected ? 1.05 : 1
        return Text(word.trunc(length: 18))
            .lineLimit(1)
            .foregroundColor(color)
            .font(.system(size: 18))
            .padding(10)
            .frame(width: wordMaxWidth)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(color, lineWidth: 1.5))
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: WordWidthPreferenceKey.self,
                    value: geometry.size.width
                )
            })
            .scaleEffect(scale)
            .padding(.vertical, 3)
            .onTapGesture {
                if (isMatchCorrect == nil) {
                    onTap()
                }
            }
    }
}

struct MatchQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = QuizesModel.MatchQuestion(id: 1, title: "Установите соответствие между английскими и русскими словами", counterCurrent: nil, counterAll: nil, pairs: ["shop": "магазин", "magazine": "журнал", "future": "будущее", "mood": "настроение"])
        
        return Group {
            MatchQuestionView(question: question)
            MatchQuestionView(question: question).preferredColorScheme(.dark)
        }
    }
}
