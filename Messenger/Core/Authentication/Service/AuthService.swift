//
//  AuthService.swift
//  Messenger
//
//  Created by Zaman Kazimov on 21.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
            loadCurrentUserData()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            // Delete user collection with user id
            try await FirestoreConstants.UserCollection.document(user.uid).delete()
            
            // Delete message collection with user id
            try await FirestoreConstants.MessagesCollection.document(user.uid).delete()
            
            // Delete user from Authentication
            try await user.delete()
            
            self.userSession = nil
            UserService.shared.currentUser = nil
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, profileImageUrl: nil)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadCurrentUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
}
