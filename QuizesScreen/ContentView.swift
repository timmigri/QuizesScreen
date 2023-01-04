import SwiftUI

struct ContentView: View {
    @ObservedObject var quizes = QuizesViewModel()
    
    var body: some View {
        Text("Some view")
//        VStack {
//            ForEach(quizes.widgets, id: \.self) { widget in
//                Text("Title")
//            }
//        }
//        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
