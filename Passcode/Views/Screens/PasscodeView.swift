//
//  PasscodeView.swift
//  Passcode
//
//  Created by Sharif on 12/11/26.
//

import SwiftUI

struct PasscodeView: View {
    let manager: PasscodeManager
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Text("Enter passcode ").font(.largeTitle).fontWeight(.heavy)
                Text("Please enter your 4-digit pin to access your account")
                    .font(.subheadline).multilineTextAlignment(.center)
            }
            .padding(.top)
            //indicator view
            // number pad view
            PasswordIndicatorView(passcode: manager.passcode)
            Spacer()

            NumberPadView(
                biometrySymbolName: manager.biometrySymbolName,
                onBiometryTapped: {
                    Task { await manager.authenticateWithBiometrics() }
                },
                onDigitTapped: manager.append,
                onDeleteTapped: manager.removeLast
            )
        }
        // Offer Face ID as soon as the lock screen appears.
        .task {
            await manager.authenticateWithBiometrics()
        }
    }
}

#Preview {
    PasscodeView(manager: PasscodeManager())
}
