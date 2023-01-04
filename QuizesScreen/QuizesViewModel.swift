import SwiftUI

class QuizesViewModel : ObservableObject {
    @Published var model: QuizesModel
    
    init() {
        model = QuizesModel(widgets: [])
    }
    
    func generateTestWidgets() -> [QuizWidget] {
        var widgets = [QuizWidget]()
        widgets.append(QuizesModel.ChoicesQuestion(title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", numberCurrent: 1, numberAll: 1, rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём b nfrflsfl", 15)]))
        widgets.append(QuizesModel.RatingStarsQuestion())
        return widgets
    }
    
    var widgets: [QuizWidget] {
        model.widgets
    }
    
    // Intents
}
