//
//  QuestionHead.swift
//  QuizesScreen
//
//  Created by Артём Грищенко on 05.01.2023.
//

import SwiftUI

struct QuestionHeadView: View {
    var title: String? = nil
    var numberCurrent: Int? = nil
    var numberAll: Int? = nil
    var aligment: HorizontalAlignment = .leading
    
    var body: some View {
        VStack(alignment: aligment) {
            if let numberCurrent = numberCurrent, let numberAll = numberAll {
                Text("Вопрос \(numberCurrent)/\(numberAll)")
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            if let title = title {
                Text(title)
                    .font(.title2)
                    .padding(.bottom, 20)
            }
        }
    }
}
