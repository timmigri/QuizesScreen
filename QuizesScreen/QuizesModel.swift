import Foundation

protocol QuizWidget {
}


struct QuizesModel {
    private(set) var widgets: [QuizWidget]
    
    struct ChoicesQuestion : QuizWidget {
        let numberCurrent: Int
        let numberAll: Int
        let question: String
        let rightAnswer: String
        let answers: [String]
    }
    
    struct MatchQuestion : QuizWidget {
        let questions: [String:String]
    }
    
    struct FillGapsWithChoicesQuestion: QuizWidget {
        let text: [(Int, String)]
        let choices: [String]
    }
    
    struct FillGapsQuestion: QuizWidget {
        let text: [(Int, String)]
    }
    
    struct RatingStarsQuestion : QuizWidget {
        let title: String?
    }
}
