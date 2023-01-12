import Foundation

protocol QuizWidget : Hashable {
    var id: Int { get }
    var title: String? { get }
    var counterCurrent: Int? { get }
    var counterAll: Int? { get }
}


struct QuizesModel {
    private(set) var widgets: [any QuizWidget]
    
    struct ChoicesQuestion : QuizWidget {
        let id: Int
        let title: String?
        let counterCurrent: Int?
        let counterAll: Int?
        
        let rightAnswer: String
        let answers: [(String, Int)]
        
        static func == (lhs: ChoicesQuestion, rhs: ChoicesQuestion) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(counterCurrent)
            hasher.combine(counterAll)
            hasher.combine(rightAnswer)
        }
    }
    
    struct MatchQuestion : QuizWidget {
        let id: Int
        let title: String?
        let counterCurrent: Int?
        let counterAll: Int?
        
        let pairs: [String:String]
    }
    
    struct FillGapsWithChoicesQuestion: QuizWidget {
        let id: Int
        let title: String?
        let counterCurrent: Int?
        let counterAll: Int?
        
        let text: [String]
        let choices: [String?]
    }
    
    struct FillGapsQuestion: QuizWidget {
        let id: Int
        let title: String?
        let counterCurrent: Int?
        let counterAll: Int?
        
        let text: String
        let answers: [String: String]
    }
    
    struct RatingStarsQuestion : QuizWidget {
        let id: Int
        let title: String?
        let counterCurrent: Int?
        let counterAll: Int?
    }

    mutating func setWidgets(widgets: [any QuizWidget]) {
        self.widgets = widgets
    }
}
