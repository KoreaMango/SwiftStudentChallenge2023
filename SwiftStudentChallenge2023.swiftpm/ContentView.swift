import SwiftUI

struct ContentView: View {
    
    @StateObject var game = Game()
    
    var body: some View {
        ZStack {
            ARVCRepresentable()
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
