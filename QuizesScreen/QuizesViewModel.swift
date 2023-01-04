import SwiftUI

class QuizesViewModel : ObservableObject {
    @Published var model: QuizesModel
    
    init() {
        model = QuizesModel(widgets: [])
        model.setWidgets(widgets: generateTestWidgets())
    }
    
    func generateTestWidgets() -> [any QuizWidget] {
        var widgets = [any QuizWidget]()
        widgets.append(QuizesModel.ChoicesQuestion(id: 1, title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", numberCurrent: 1, numberAll: 1, rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём b nfrflsfl", 15)]))
        widgets.append(QuizesModel.RatingStarsQuestion(id: 2, title: "Оцените прошлый вопрос"))
        widgets.append(QuizesModel.RatingStarsQuestion(id: 3))
        return widgets
    }
    
    var widgets: [any QuizWidget] {
        model.widgets
    }
    
    // Intents
}
