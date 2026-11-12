//
//  ContentView.swift
//  Passcode
//
//  Created by Sharif on 12/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var manager = PasscodeManager()
    
    var body: some View {
        VStack{
            if manager.isAuthenticated {
                Text("You're in!")
                Button("Log Out"){
                    manager.logOut()
                }
            } else {
                PasscodeView(manager: manager)
            }
        }
     
    }
}

#Preview {
    ContentView()
}
