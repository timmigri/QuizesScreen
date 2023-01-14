//
//  RatingStarsQuestionView.swift
//  QuizesScreen
//
//  Created by Артём Грищенко on 05.01.2023.
//

import SwiftUI

struct RatingStarsQuestionView: View {
    let question: QuizesModel.RatingStarsQuestion
    
    @State var selectedRating: Int? = nil
    @State var scales: [CGFloat] = [1, 1, 1, 1, 1]
    
    var isSelected: Bool {
        selectedRating != nil
    }
    
    var isAnimationInProgress: Bool {
        if let selectedRating = selectedRating {
            for index in 0..<selectedRating {
                if (scales[index] != 1) {
                    return true
                }
            }
        }
        return false
    }
    
    var body: some View {
        VStack {
            QuestionHeadView(question: question)
            HStack {
                ForEach(1..<6) { index in
                    Image(systemName: iconName(index: index))
                        .font(.system(size: Constants.fontSize))
                        .foregroundColor(Constants.color)
                        .scaleEffect(scales[index - 1])
                        .onTapGesture {
                            if (!isAnimationInProgress) {
                                selectedRating = index
                                animate()
                            }
                        }
                }
            }
        }
        .padding(GlobalConstants.quizesWidgetPadding)
        .frame(maxWidth: .infinity)
    }
    
    func animate() {
        if let selectedRating = selectedRating {
            for index in 0...selectedRating {
                let delay: CGFloat = Double(index) * Constants.animationDelayCoef
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation {
                        if (index < selectedRating) {
                            scales[index] = Constants.animationScale
                        }
                        if (index > 0) {
                            scales[index - 1] = 1
                        }
                    }
                }
            }
        }
    }
                          
    func iconName(index: Int) -> String {
        if (selectedRating == nil || index > selectedRating!) {
            return "star"
        }
        return "star.fill"
    }
    
    private struct Constants {
        static let fontSize: CGFloat = 40
        static let color: Color = .orange
        static let animationScale: CGFloat = 1.25
        static let animationDelayCoef: CGFloat = 0.15
    }
}

struct RatingStarsQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let question = QuizesModel.RatingStarsQuestion(
            id: 1,
            title: nil,
            counterCurrent: nil,
            counterAll: nil
        )
        return Group {
            RatingStarsQuestionView(question: question)
            RatingStarsQuestionView(question: question).preferredColorScheme(.dark)
        }
    }
}
