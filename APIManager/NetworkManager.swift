//
//  NetworkManager.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import Foundation
import Combine

enum RequestType:String {
    case POST
    case GET
    case PUT
    
}
enum MyRecipeError: Error {
    
    case ServerError
    case URLError
    case JsonParseError
    case networkError(Error)
    case invalidUrl
    case InvalidResponse
    case InvalidUser
    case NoData
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func createRequest<T: Decodable>(
        url: URL,
        requestType: RequestType,
    ) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                                  200..<300 ~= httpResponse.statusCode else {
                                throw MyRecipeError.ServerError
                            }
                return result.data
            }.decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return MyRecipeError.JsonParseError
                } else {
                    return MyRecipeError.networkError(error)
                }
            }.eraseToAnyPublisher()
        
    }
    
    
    func createRequest<T: Decodable, U: Encodable>(
            url: URL,
            requestType: RequestType,
            postData: U
        ) -> AnyPublisher<T, Error> {
            
            var request = URLRequest(url: url)
            request.httpMethod = requestType.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(postData)
            } catch {
                return Fail(error: MyRecipeError.JsonParseError)
                    .eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { result -> Data in
                    guard let httpResponse = result.response as? HTTPURLResponse,
                          200..<300 ~= httpResponse.statusCode else {
                        throw MyRecipeError.ServerError
                    }
                    return result.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    if error is DecodingError {
                        return MyRecipeError.JsonParseError
                    } else {
                        return MyRecipeError.networkError(error)
                    }
                }
                .eraseToAnyPublisher()
        }
}

