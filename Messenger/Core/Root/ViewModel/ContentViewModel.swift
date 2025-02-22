//
//  ContentViewModel.swift
//  Messenger
//
//  Created by Zaman Kazimov on 21.02.25.
//

import Foundation
import FirebaseAuth
import Combine


class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellables)
    }
}
