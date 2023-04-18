import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    LaunchView()
                    NavigationLink(destination: {
                        ContentView()
                    }, label: {
                        Text("Start!")
                        .frame(maxWidth:.infinity, maxHeight: 60)
                        .buttonStyle(.borderless)
                        .foregroundColor(.black)
                        .overlay {
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.black, lineWidth: 1)
                        }
                        .padding(25)
                    })
                    .navigationTitle("")
                   
                }
            }
        }
    }
}
