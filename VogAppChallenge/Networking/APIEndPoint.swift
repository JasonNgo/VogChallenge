//
//  APIEndPoint.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-03-29.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

enum APIEndPoint {
    case fetchProfileInformation
    case updateProfileInformation(firstName: String, lastName: String)
    case updatePasswordInformation(currentPwd: String, newPwd: String, pwdConfirmation: Bool)
}

extension APIEndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://api.foo.com") else {
            preconditionFailure("Invalid base URL")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .fetchProfileInformation:
            return "/profiles/mine"
        case .updateProfileInformation:
            return "/profiles/update"
        case .updatePasswordInformation:
            return "/password/change"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchProfileInformation:
            return .GET
        case .updatePasswordInformation:
            return .POST
        case .updateProfileInformation:
            return .POST
        }
    }
    
    var httpBody: [String: Any] {
        switch self {
        case .fetchProfileInformation:
            return [:]
        case .updateProfileInformation(let firstName, let lastName):
            return [
                "firstName": firstName,
                "lastName": lastName
            ]
        case .updatePasswordInformation(let currentPwd, let newPwd, let pwdConfirmation):
            return [
                "currentPassword": currentPwd,
                "newPassword": newPwd,
                "passwordConfirmation": pwdConfirmation
            ]
        }
    }
}
