//
//  RatingStarsQuestionView.swift
//  QuizesScreen
//
//  Created by Артём Грищенко on 05.01.2023.
//

import SwiftUI

struct RatingStarsQuestionView: View {
    var title: String? = nil
    
    @State var selectedRating: Int? = nil
    @State var scales: [CGFloat] = [1, 1, 1, 1, 1]
    var body: some View {
        VStack {
            QuestionHeadView(title: title)
            HStack {
                ForEach(1..<6) { index in
                    Image(systemName: iconName(index: index))
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                        .scaleEffect(scales[index - 1])
                        .onTapGesture {
                            if (!isAnimationInProgress()) {
                                selectedRating = index
                                animate()
                            }
                        }
                }
            }
        }.padding(15)
    }
    
    func animate() {
        if let selectedRating = selectedRating {
            for index in 0...selectedRating {
                let delay: CGFloat = Double(index) * 0.15
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation {
                        if (index < selectedRating) {
                            scales[index] = 1.25
                        }
                        if (index > 0) {
                            scales[index - 1] = 1
                        }
                    }
                }
            }
        }
    }
    
    func isAnimationInProgress() -> Bool {
        if let selectedRating = selectedRating {
            for index in 0..<selectedRating {
                if (scales[index] != 1) {
                    return true
                }
            }
        }
        return false
    }
                          
    func iconName(index: Int) -> String {
        if (selectedRating == nil || index > selectedRating!) {
            return "star"
        }
        return "star.fill"
    }
    
    var isSelected: Bool {
        selectedRating != nil
    }
}

struct RatingStarsQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStarsQuestionView(title: "Оцените данный пост")
        RatingStarsQuestionView().preferredColorScheme(.dark)
    }
}
