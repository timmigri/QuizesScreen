//
//  QuestionHead.swift
//  QuizesScreen
//
//  Created by Артём Грищенко on 05.01.2023.
//

import SwiftUI

struct QuestionHeadView: View {
    let question: any QuizWidget
    
    private var vstackAligment: HorizontalAlignment {
        if question as? QuizesModel.RatingStarsQuestion != nil {
            return .center
        }
        return .leading
    }
    
    private var textAligment: TextAlignment {
        if question as? QuizesModel.RatingStarsQuestion != nil {
            return .center
        }
        return .leading
    }
    
    var body: some View {
        VStack(alignment: vstackAligment) {
            if let counterCurrent = question.counterCurrent, let counterAll = question.counterAll {
                Text("Вопрос \(counterCurrent)/\(counterAll)")
                    .foregroundColor(Constants.Counter.color)
                    .padding(.bottom, Constants.Counter.paddingBottom)
                    .multilineTextAlignment(textAligment)
            }
            if let title = question.title {
                Text(title)
                    .font(Constants.Title.font)
                    .padding(.bottom, Constants.Title.paddingBottom)
                    .multilineTextAlignment(textAligment)
            }
        }
    }
    
    private struct Constants {
        struct Counter {
            static let color: Color = .gray
            static let paddingBottom: CGFloat = 10
        }
        struct Title {
            static let font: Font = .title2
            static let paddingBottom: CGFloat = 10
        }
    }
}
