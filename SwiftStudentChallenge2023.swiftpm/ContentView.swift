import SwiftUI

struct ContentView: View {
    
    @StateObject var game = Game()
    
    var body: some View {
        ZStack {
            ARVCRepresentable()
            VStack {
                Text("\(game.score)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    game.score += 1
                } label: {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                }

            }
            .padding(.all, 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

//MARK: VC
struct ARVCRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ARViewController()
    }
}
