//
//  Constants.swift
//  Messenger
//
//  Created by Zaman Kazimov on 22.02.25.
//

import Foundation
import FirebaseFirestore

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("messages")
}
