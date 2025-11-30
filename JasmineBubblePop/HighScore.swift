import SwiftUI

struct HighScore: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var scores: [(name: String, score: Int)] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("High Score")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()

                // list players and scores
                List(scores, id: \.name) { entry in
                    HStack {
                        Text(entry.name)
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                        Spacer()
                        Text("\(entry.score)")
                            .font(.title3)
                            .foregroundColor(.pink)
                    }
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.6))
                    )
                    .listRowBackground(Color.clear) 
                }
                .listStyle(PlainListStyle())


                Spacer()
                
                // Link to ContentView
                NavigationLink(
                    destination: ContentView(),
                    label: {
                        Text("Return to Main")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(15)
                    })
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.pink.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .onAppear {
            loadScores()
        }
    }

    private func loadScores() {
        if let savedScores = UserDefaults.standard.array(forKey: "HighScores") as? [[String: Any]] {
            var loadedScores = savedScores.compactMap { dict in
                if let name = dict["name"] as? String, let score = dict["score"] as? Int {
                    return (name: name, score: score)
                }
                return nil
            }
            
            loadedScores.sort { $0.score > $1.score }
            
            var uniqueScores: [String: (name: String, score: Int)] = [:]
            for entry in loadedScores {
                if uniqueScores[entry.name] == nil {
                    uniqueScores[entry.name] = entry
                }
            }
            
            scores = Array(uniqueScores.values)
            scores.sort { $0.score > $1.score }
        }
    }

}

#Preview {
    HighScore()
}
