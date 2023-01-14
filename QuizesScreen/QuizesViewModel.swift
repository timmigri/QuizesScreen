import SwiftUI

class QuizesViewModel : ObservableObject {
    @Published var model: QuizesModel
    
    init() {
        model = QuizesModel(widgets: [])
        model.setWidgets(widgets: generateTestWidgets())
    }
    
    func generateTestWidgets() -> [any QuizWidget] {
        var widgets = [any QuizWidget]()
        let counterAll = 4
        
        widgets.append(
            QuizesModel.ChoicesQuestion(
                id: 1,
                title: "Что происходило с главным героем фильма «Загадочная история Бенджамина Баттона»?",
                counterCurrent: 1,
                counterAll: counterAll,
                answers: [
                    QuizesModel.ChoicesQuestion.Answer(id: 1, title: "Он научился летать", percent: 13),
                    QuizesModel.ChoicesQuestion.Answer(id: 2, title: "Он родился старым и молодел", percent: 60),
                    QuizesModel.ChoicesQuestion.Answer(id: 3, title: "Он умел предсказывать будущее", percent: 12),
                    QuizesModel.ChoicesQuestion.Answer(id: 4, title: "Он становился больше с каждым днём", percent: 15)
                ],
                rightAnswerId: 2
            )
        )
        
        widgets.append(
            QuizesModel.FillGapsQuestion(
                id: 2,
                title: "Заполните пропуски",
                counterCurrent: 2,
                counterAll: counterAll,
                text: "\"Джентельмены\" - криминальная комедия режиссёра Гая {key1} по собственному сценарию. Главные роли в фильме исполняют Чарли Ханнэм, Генри Голдинг, Мишель Докери, Колин Фаррелл, Хью Грант и Мэттью {key2}. Бюджет фильма составил ${key3} млн\n{key4} Вильгельм Ди Каприо - американский актёр и продюсер, родился 11 ноября {key5} в Лос-Анджелесе, США. Всемирная известность обрушилась на актёра благодаря главной роли в фильме-катастрофе \"{key6}\". Первый и пока свой единственный «Оскар» ДиКаприо получил в 2016 году за роль в драме \"{key7}\"",
                answers: [
                    "key1": "Ричи",
                    "key2": "Макконахи",
                    "key3": "22",
                    "key4": "Леонардо",
                    "key5": "1974",
                    "key6": "Титаник",
                    "key7": "Выживший"
                ]
            )
        )
        widgets.append(
            QuizesModel.RatingStarsQuestion(
                id: 3,
                title: "Оцените прошлые вопросы",
                counterCurrent: nil,
                counterAll: nil
            )
        )
        
        widgets.append(
            QuizesModel.MatchQuestion(
                id: 4,
                title: "Установите соответствие между английскими и русскими словами",
                counterCurrent: 3,
                counterAll: counterAll,
                pairs: ["shop": "магазин", "magazine": "журнал", "future": "будущее", "mood": "настроение"]
            )
        )
        widgets.append(
            QuizesModel.FillGapsWithChoicesQuestion(
                id: 5,
                title: "Заполните пропуски в тексте о Rammstein",
                counterCurrent: 4,
                counterAll: counterAll,
                text: "Группа Rammstein была основана в январе {key1} года в {key2} гитаристом Рихардом {key3}. Помимо него в состав группы на данный момент входят Тилль Линдеманн, Пауль Ландерс, Оливер Ридель, Кристоф Шнайдер и Кристиан {key5}. Музыкальный стиль группы относится к жанру {key4}",
                choices: [
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 1, title: "1997", forKey: nil),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 2, title: "Бремене", forKey: nil),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 3, title: "индастриал-метала", forKey: "key4"),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 4, title: "Круспе", forKey: "key3"),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 5, title: "инди-рока", forKey: nil),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 6, title: "Лоренц", forKey: "key5"),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 7, title: "Берлине", forKey: "key2"),
                    QuizesModel.FillGapsWithChoicesQuestion.Choice(id: 8, title: "1994", forKey: "key1"),
                ]
            )
        )
        
        widgets.append(
            QuizesModel.RatingStarsQuestion(
                id: 6,
                title: "Общее впечателение от приложения",
                counterCurrent: nil,
                counterAll: nil
            )
        )
        return widgets
    }
    
    var widgets: [any QuizWidget] {
        model.widgets
    }
    
    // Intents
}
