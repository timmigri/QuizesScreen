import Foundation

protocol QuizWidget {
    var title: String? { get set }
}


struct QuizesModel {
    private(set) var widgets: [QuizWidget]
    
    struct ChoicesQuestion : QuizWidget {
        var title: String?
        let numberCurrent: Int
        let numberAll: Int
        let rightAnswer: String
        let answers: [(String, Int)]
    }
    
    struct MatchQuestion : QuizWidget {
        var title: String?
        let questions: [String:String]
    }
    
    struct FillGapsWithChoicesQuestion: QuizWidget {
        var title: String?
        let text: [(Int, String)]
        let choices: [String]
    }
    
    struct FillGapsQuestion: QuizWidget {
        var title: String?
        let text: [(Int, String)]
    }
    
    struct RatingStarsQuestion : QuizWidget {
        var title: String?
    }
}
