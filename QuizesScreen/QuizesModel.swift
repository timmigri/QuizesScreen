import Foundation

protocol QuizWidget : Hashable {
    var id: Int { get set }
    var title: String? { get set }
}


struct QuizesModel {
    private(set) var widgets: [any QuizWidget]
    
    struct ChoicesQuestion : QuizWidget {
        var id: Int
        var title: String?
        let numberCurrent: Int
        let numberAll: Int
        let rightAnswer: String
        let answers: [(String, Int)]
        
        static func == (lhs: ChoicesQuestion, rhs: ChoicesQuestion) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(numberCurrent)
            hasher.combine(numberAll)
            hasher.combine(rightAnswer)
        }
    }
    
    struct MatchQuestion : QuizWidget {
        var id: Int
        var title: String?
        let pairs: [String:String]
    }
    
    struct FillGapsWithChoicesQuestion: QuizWidget {
        var id: Int
        var title: String?
        let text: [String]
        let choices: [String?]
    }
    
    struct FillGapsQuestion: QuizWidget {
        var id: Int
        var title: String?
        let text: String
    }
    
    struct RatingStarsQuestion : QuizWidget {
        var id: Int
        var title: String?
    }

    mutating func setWidgets(widgets: [any QuizWidget]) {
        self.widgets = widgets
    }
}
