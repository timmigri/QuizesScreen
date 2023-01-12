import SwiftUI

struct ContentView: View {
    @ObservedObject var quizes = QuizesViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ForEach(quizes.widgets, id: \.id) { item in
    //                if let widget = item as? QuizesModel.ChoicesQuestion {
    //                    ChoicesQuestionView(question: widget)
    //                }
    //                if let widget = item as? QuizesModel.MatchQuestion {
    //                    MatchQuestionView(question: widget)
    //                }
                    if let widget = item as? QuizesModel.FillGapsQuestion {
                        FillGapsQuestionView(question: widget, screenGeometry: geometry)
                    }
    //                if let widget = item as? QuizesModel.RatingStarsQuestion {
    //                    RatingStarsQuestionView(title: widget.title)
    //                }
                    Divider()
                }
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
