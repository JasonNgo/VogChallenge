//
//  User.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-04-06.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

struct User {
    var firstName: String?
    var lastName: String?
    var userName: String?
}

extension User {
    init(dictionary: [String: Any]) {
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.userName = dictionary["userName"] as? String
    }
}

extension User: Decodable {}
