import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ARVCRepresentable()
        }
    }
}

//MARK: VC
struct ARVCRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ARViewController()
    }
}
