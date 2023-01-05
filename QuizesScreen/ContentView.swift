import SwiftUI

struct ContentView: View {
    @ObservedObject var quizes = QuizesViewModel()
    
    var body: some View {
        ScrollView {
            FillGapsQuestionView()
            ForEach(quizes.widgets, id: \.id) { item in
                if let widget = item as? QuizesModel.ChoicesQuestion {
                    ChoicesQuestionView(question: widget)
                }
                if let widget = item as? QuizesModel.MatchQuestion {
                    MatchQuestionView(question: widget)
                }
                if let widget = item as? QuizesModel.RatingStarsQuestion {
                    RatingStarsQuestionView(title: widget.title)
                }
                Divider()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().preferredColorScheme(.dark)
    }
}
