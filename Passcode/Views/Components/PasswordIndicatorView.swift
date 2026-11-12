//
//  PasswordIndicatorView.swift
//  Passcode
//
//  Created by Sharif on 12/11/26.
//
import SwiftUI

struct PasswordIndicatorView: View {
    let passcode: String
    var body: some View {
        HStack(spacing: 32) {
            ForEach(0..<PasscodeManager.length, id: \.self) {
                index in
                Circle().fill(passcode.count > index ?  .primary: Color(.white)).frame(width: 20, height: 20).overlay(
                    Circle().stroke(.black, lineWidth: 1.0)
                )
            }
        }
    }
}
#Preview {
    PasswordIndicatorView(passcode: "123")
}
