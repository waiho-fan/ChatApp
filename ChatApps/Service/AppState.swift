//
//  AppState.swift
//  ChatApps
//
//  Created by Gary on 13/3/2025.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var authError: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        UserAuthService.shared.$currentUser
            .receive(on: RunLoop.main)
            .map { $0 != nil }
            .assign(to: \.isAuthenticated, on:self)
            .store(in: &cancellables)
    }
    
}
