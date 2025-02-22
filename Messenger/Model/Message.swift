//
//  Message.swift
//  Messenger
//
//  Created by Zaman Kazimov on 22.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageId: String?
    
    let fromId: String
    let toId: String
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?
    
    var id: String {
        return messageId ?? UUID().uuidString
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var timestampString: String {
        return timestamp.dateValue().timestampString()
    }
}
