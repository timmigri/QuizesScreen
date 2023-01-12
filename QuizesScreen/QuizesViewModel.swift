import SwiftUI

class QuizesViewModel : ObservableObject {
    @Published var model: QuizesModel
    
    init() {
        model = QuizesModel(widgets: [])
        model.setWidgets(widgets: generateTestWidgets())
    }
    
    func generateTestWidgets() -> [any QuizWidget] {
        var widgets = [any QuizWidget]()
        widgets.append(QuizesModel.FillGapsQuestion(id: 0, title: nil, counterCurrent: nil, counterAll: nil, text: "Заполните{key1}пропуски{key2}в тексте{key3}Какой-то текст дальше...", answers: ["key1": "abc", "key2": "kek", "key3": "lol"]))
        widgets.append(QuizesModel.FillGapsQuestion(id: 10, title: nil, counterCurrent: nil, counterAll: nil, text: "Заполните{key1}пропуски{key2}в тексте{key3}Какой-то текст дальше...", answers: ["key1": "abc", "key2": "kek", "key3": "lol"]))
        widgets.append(QuizesModel.FillGapsQuestion(id: 120, title: nil, counterCurrent: nil, counterAll: nil, text: "Заполните{key1}пропуски{key2}в тексте{key3}Какой-то текст дальше...", answers: ["key1": "abc", "key2": "kek", "key3": "lol"]))
        widgets.append(QuizesModel.FillGapsQuestion(id: 1230, title: nil, counterCurrent: nil, counterAll: nil, text: "Заполните{key1}пропуски{key2}в тексте{key3}Какой-то текст дальше...", answers: ["key1": "abc", "key2": "kek", "key3": "lol"]))
        widgets.append(QuizesModel.ChoicesQuestion(id: 1, title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?", counterCurrent: 1, counterAll: 1, rightAnswer: "Он родился старым и молодел", answers: [("Он научился летать", 13), ("Он родился старым и молодел", 60), ("Он умел предсказывать будущее", 12), ("Он становился больше с каждым днём", 15)]))
        widgets.append(QuizesModel.RatingStarsQuestion(id: 2, title: "Оцените прошлый вопрос", counterCurrent: nil, counterAll: nil))
        widgets.append(QuizesModel.MatchQuestion(id: 3, title: "Установите соответствие между английскими и русскими словами", counterCurrent: nil, counterAll: nil, pairs: ["shop": "магазин", "magazine": "журнал", "future": "будущее", "mood": "настроение"]))
        widgets.append(QuizesModel.RatingStarsQuestion(id: 4, title: nil, counterCurrent: nil, counterAll: nil))
        return widgets
    }
    
    var widgets: [any QuizWidget] {
        model.widgets
    }
    
    // Intents
}
