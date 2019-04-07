//
//  APIService.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-03-29.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

public enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

enum APIServiceError: Error {
    case unableToSerializeHTTPBody(Error)
    case requestError(Error)
    case invalidResponse
    case invalidResponseCode
    case invalidData
}

class APIService {
    private init() {}
    static let shared = APIService()
    
    func mockRequest(_ endpoint: APIEndPoint, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
        switch endpoint {
        case .fetchProfileInformation:
            guard let url = Bundle.main.url(forResource: "profileResponse", withExtension: "json") else {
                preconditionFailure()
            }
            
            do {
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch {
                
            }
            
        case .updateProfileInformation(_, _):
            guard let url = Bundle.main.url(forResource: "profilePOSTResponse", withExtension: "json") else {
                preconditionFailure()
            }
            
            do {
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch {
                
            }
            
        case .updatePasswordInformation(_, _, _):
            guard let url = Bundle.main.url(forResource: "passwordPOSTResponse", withExtension: "json") else {
                preconditionFailure()
            }
            
            do {
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch {
                
            }            
        }
    }
    
    // If we were to build and make an actual request
    func request(_ endpoint: APIEndPoint, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: endpoint.httpBody, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        } catch let error {
            completion(.failure(APIServiceError.unableToSerializeHTTPBody(error)))
        }

        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(APIServiceError.requestError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIServiceError.invalidResponse))
                return
            }
            
            if httpResponse.statusCode != 200 {
                completion(.failure(APIServiceError.invalidResponseCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIServiceError.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }

}

