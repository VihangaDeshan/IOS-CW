//
//  AppRouter.swift
//  IOS Clinic App
//
//  Centralised navigation state.
//  Uses the @Observable macro (iOS 17+) so any view in the hierarchy
//  that reads `currentRoute` automatically re-renders on change.
//

import SwiftUI
import Observation

// MARK: - Route Enum

enum AppRoute: Hashable {
    case onboarding
    case welcome
    case login
    case verifyOTP
    case register
    case checkIn
    case scanQR
    case main
}

// MARK: - Router


@Observable
final class AppRouter {

    private let authKey  = "isAuthorized"
    private let guestKey = "isGuest"

    var isAuthorized: Bool {
        didSet { UserDefaults.standard.set(isAuthorized, forKey: authKey) }
    }

    var isGuest: Bool {
        didSet { UserDefaults.standard.set(isGuest, forKey: guestKey) }
    }

    var currentRoute: AppRoute = .onboarding
    var mainResetToken = UUID()

    init() {
        self.isAuthorized = UserDefaults.standard.bool(forKey: authKey)
        self.isGuest      = UserDefaults.standard.bool(forKey: guestKey)
    }

    // Animate every route change through the standard easing curve.
    func navigate(to route: AppRoute) {
        withAnimation(.easeInOut(duration: 0.38)) {
            currentRoute = route
        }
    }

    func resetToHomeDashboard() {
        withAnimation(.easeInOut(duration: 0.38)) {
            currentRoute = .main
            mainResetToken = UUID()
        }
    }

    func logout() {
        isAuthorized = false
        isGuest      = false
    }
}
