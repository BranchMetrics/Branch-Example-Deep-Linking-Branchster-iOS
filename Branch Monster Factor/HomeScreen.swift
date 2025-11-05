//
//  HomeScreen.swift
//  Branch Monster Factor
//
//  Created by Robert Gioia on 11/5/25.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage("selectedMonsterName") private var selectedMonsterName: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 0.165, green: 0.176, blue: 0.196).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {

                Image(selectedMonsterName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
    }
}
