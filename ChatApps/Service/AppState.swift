//
//  AppState.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 13/3/2025.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var authError: String? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    let userDidLoginPublisher = PassthroughSubject<Void, Never>()
    let userDidLogoutPublisher = PassthroughSubject<Void, Never>()
    
    @Published private var previousUserId: String?
    
    init() {
        UserAuthService.shared.$currentUser
            .receive(on: RunLoop.main)
            .map { $0 != nil }
            .assign(to: \.isAuthenticated, on:self)
            .store(in: &cancellables)
        
        UserAuthService.shared.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                
                if let user = user {
                    let userId = user.id
                    
                    if self.previousUserId == nil || self.previousUserId != userId {
                        print("Sending userDidLoginPublisher")
                        self.userDidLoginPublisher.send()
                    }
                    
                    self.previousUserId = userId
                } else if self.previousUserId != nil {
                    print("Sending userDidLogoutPublisher")
                    self.userDidLogoutPublisher.send()
                    self.previousUserId = nil
                }
            }
            .store(in: &cancellables)
    }
    
}

extension AppState {
    static let shared = AppState()
}
