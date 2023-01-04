import SwiftUI

class QuizesViewModel : ObservableObject {
    @Published var model: QuizesModel
    
    init() {
        model = QuizesModel(widgets: [])
    }
    
    // Intents
}
