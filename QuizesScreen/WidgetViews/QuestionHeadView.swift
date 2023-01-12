//
//  QuestionHead.swift
//  QuizesScreen
//
//  Created by Артём Грищенко on 05.01.2023.
//

import SwiftUI

struct QuestionHeadView: View {
    let question: any QuizWidget
    
    var body: some View {
        VStack {
            if let counterCurrent = question.counterCurrent, let counterAll = question.counterAll {
                Text("Вопрос \(counterCurrent)/\(counterAll)")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            if let title = question.title {
                Text(title)
                    .font(.title2)
                    .padding(.bottom, 20)
            }
        }
    }
}
