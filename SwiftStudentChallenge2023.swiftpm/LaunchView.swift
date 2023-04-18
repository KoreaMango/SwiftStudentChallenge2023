//
//  LaunchView.swift
//  SwiftStudentChallenge2023
//
//  Created by 강민규 on 2023/04/17.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Text("Tuho Game")
                .font(.custom("HelveticaNeue", size: 60))
                .fontWeight(.bold)
                .padding(20)
            Text(" **Tuho** is a traditional Korean folk game in which arrows are thrown into pots.\n There is a record of **Tuho** in Korea about 1,000 years ago. \n\n **Tuho** is so famous that it was on a 1,000 won bill issued in 1983. \n\n Create jars and arrows with AR to enjoy **Tuho**!")
                .padding(20)
                .font(.custom("HelveticaNeue", size: 24))
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
