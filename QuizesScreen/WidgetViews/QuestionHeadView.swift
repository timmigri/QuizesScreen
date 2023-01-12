//
//  QuestionHead.swift
//  QuizesScreen
//
//  Created by Артём Грищенко on 05.01.2023.
//

import SwiftUI

struct QuestionHeadView: View {
    let question: any QuizWidget
    
    var vstackAligment: HorizontalAlignment {
        if question as? QuizesModel.RatingStarsQuestion != nil {
            return .center
        }
        return .leading
    }
    
    var textAligment: TextAlignment {
        if question as? QuizesModel.RatingStarsQuestion != nil {
            return .center
        }
        return .leading
    }
    
    var body: some View {
        VStack(alignment: vstackAligment) {
            if let counterCurrent = question.counterCurrent, let counterAll = question.counterAll {
                Text("Вопрос \(counterCurrent)/\(counterAll)")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(textAligment)
            }
            if let title = question.title {
                Text(title)
                    .font(.title2)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(textAligment)
            }
        }
    }
}
