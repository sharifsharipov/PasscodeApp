//
//  PasscodeManager.swift
//  Passcode
//
//  Created by Sharif on 12/11/26.
//

import Foundation
import LocalAuthentication
import Observation

/// Owns the passcode state and authentication rules so the views only render UI.
@MainActor
@Observable
final class PasscodeManager {
    static let length = 4

    private let correctPasscode: String
    private let verificationDelay: Duration

    private(set) var passcode = ""
    private(set) var isAuthenticated = false
    /// The biometry the device offers (Face ID, Touch ID, Optic ID), or `.none` if it's unavailable or not enrolled.
    private(set) var biometryType: LABiometryType = .none

    init(correctPasscode: String = "1111", verificationDelay: Duration = .milliseconds(125)) {
        self.correctPasscode = correctPasscode
        self.verificationDelay = verificationDelay
    }

    var isBiometryAvailable: Bool { biometryType != .none }

    /// SF Symbol for the device's biometry, used by the number pad button.
    var biometrySymbolName: String? {
        switch biometryType {
        case .faceID: "faceid"
        case .touchID: "touchid"
        case .opticID: "opticid"
        case .none: nil
        @unknown default: nil
        }
    }

    func append(_ digit: Int) {
        guard passcode.count < Self.length else { return }
        passcode += "\(digit)"

        if passcode.count == Self.length {
            Task { await verifyPasscode() }
        }
    }

    func removeLast() {
        guard !passcode.isEmpty else { return }
        passcode.removeLast()
    }

    /// Waits briefly so the last indicator dot is visible, then checks the passcode and clears it.
    func verifyPasscode() async {
        guard passcode.count == Self.length else { return }
        try? await Task.sleep(for: verificationDelay)
        isAuthenticated = passcode == correctPasscode
        passcode = ""
    }

    func logOut() {
        passcode = ""
        isAuthenticated = false
    }

    /// Reads which biometry the device supports. `biometryType` is only meaningful after `canEvaluatePolicy`.
    func refreshBiometryAvailability() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometryType = context.biometryType
        } else {
            biometryType = .none
        }
    }

    /// Prompts for Face ID / Touch ID. If it fails or is cancelled, the user can still enter the passcode.
    func authenticateWithBiometrics() async {
        refreshBiometryAvailability()
        guard isBiometryAvailable, !isAuthenticated else { return }

        // A fresh context per attempt, so a previous success isn't reused.
        let context = LAContext()
        context.localizedFallbackTitle = String(localized: "Enter Passcode")

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: String(localized: "Unlock to access your account")
            )
            if success {
                passcode = ""
                isAuthenticated = true
            }
        } catch {
            // Cancelled, failed, or the user chose the fallback: stay on the passcode screen.
        }
    }
}
