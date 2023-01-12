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
        let answers: [Answer]
        let rightAnswerId: Int
        
        struct Answer : Hashable {
            let id: Int
            let title: String
            let percent: Int
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
        
        let text: String
        let choices: [Choice]
        
        struct Choice : Hashable {
            let id: Int
            let title: String
            let forKey: String?
        }
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
