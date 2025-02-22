//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Zaman Kazimov on 21.02.25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
