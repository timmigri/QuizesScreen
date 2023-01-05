import SwiftUI

struct MatchQuestionView: View {
    let question: QuizesModel.MatchQuestion
    @State var firstWords: [String]
    @State var secondWords: [String]
    @State var firstWordsSelectedIndex: Int? = nil
    @State var secondWordsSelectedIndex: Int? = nil
    @State var isMatchCorrect: Bool? = nil
    
    init(question: QuizesModel.MatchQuestion) {
        self.question = question
        _firstWords = State(initialValue: question.pairs.map{ key, value in key }.shuffled())
        _secondWords = State(initialValue: question.pairs.map{ key, value in value }.shuffled())
    }
    
    var body: some View {
        VStack {
            QuestionHeadView(title: question.title)
            ZStack {
                HStack {
                    VStack {
                        ForEach(Array(firstWords.enumerated()), id: \.element) { (index, word) in
                            renderWord(word: word, isSelected: index == firstWordsSelectedIndex) {
                                //                            withAnimation(.easeOut(duration: 0.1)){
                                firstWordsSelectedIndex = (index != firstWordsSelectedIndex ? index : nil)
                                //                            }
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
                wrongSelectionIcon
            }
        }
        .padding(15)
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
                    clearSelection()
                    firstWords.remove(at: firstIndex)
                    secondWords.remove(at: secondIndex)
                }
            } else {
                isMatchCorrect = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    clearSelection()
                }
            }
        }
    }
    
    func getWordColor(isSelected: Bool) -> Color {
        if (!isSelected) {
            return .black
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
    }
    
    func renderWord(word: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        let color = getWordColor(isSelected: isSelected)
        let scale = isSelected ? 1.05 : 1
        return Text(word)
            .foregroundColor(color)
            .font(.system(size: 18))
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(color, lineWidth: 1.5))
            .scaleEffect(scale)
            .padding(.vertical, 3)
            .onTapGesture(perform: onTap)
    }
}

struct MatchQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        MatchQuestionView(question: QuizesModel.MatchQuestion(id: 1, title: "Установите соответствие между английскими и русскими словами", pairs: ["shop": "магазин", "magazine": "журнал", "future": "будущее", "mood": "настроение"]))
        MatchQuestionView(question: QuizesModel.MatchQuestion(id: 1, title: "Установите соответствие между английскими и русскими словами", pairs: ["shop": "магазин", "magazine": "журнал", "future": "будущее", "mood": "настроение"])).preferredColorScheme(.dark)
    }
}
