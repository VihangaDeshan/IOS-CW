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
    case main
   
}

// MARK: - Router


@Observable
final class AppRouter {

    var currentRoute: AppRoute = .onboarding

    // Animate every route change through the standard easing curve.
    func navigate(to route: AppRoute) {
        withAnimation(.easeInOut(duration: 0.38)) {
            currentRoute = route
        }
    }
    
    var isAuthorized: Bool = true // Track if user is logged in
    
    func logout() {
        isAuthorized = false
        // Clear any paths if you use a NavigationPath
    }
}
