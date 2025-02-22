//
//  Route.swift
//  Messenger
//
//  Created by Zaman Kazimov on 22.02.25.
//

import Foundation

enum Route: Hashable {
    case profile(User)
    case chatView(User)
}
