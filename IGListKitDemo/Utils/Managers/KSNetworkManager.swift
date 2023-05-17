//
//  KSNetworkManager.swift
//  IGListKitDemo
//
//  Created by Kedar Sukerkar on 15/05/23.
//

import Foundation
import Combine

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}




public enum NetworkError: LocalizedError{
    
    case noInternet
    case parsingError
    
    public var errorDescription: String? {
        switch self {
            case .noInternet:
                return NSLocalizedString("No internet found.", comment: "No Internet Error")
            case .parsingError:
                return NSLocalizedString("Json parsing failed", comment: "JSON Parsing Error")
                
        }
    }
}

public struct KSNetworkManager {
    
    // MARK: - Properties
    public var baseURL = ""
    private let ksSession: URLSession?
    
    
    // MARK: - Initializer
    public init(baseURL: String) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        
        self.ksSession = URLSession(configuration: configuration)
        self.baseURL = baseURL
    }
    
    
    
    // MARK: - Request Helpers
    public func sendRequest<T: Decodable>(
        methodType:HTTPMethod,
        apiName:String,
        parameters:[String:Any]?,
        headers:[String:Any]?) -> AnyPublisher<T, NetworkError>?{
            
            
            guard let urlString = URL(string: self.baseURL + apiName) else{return nil}
            // debugPrint(urlString)
            
            var request = URLRequest(url: urlString, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 12)
            request.httpMethod = methodType.rawValue
            
            return self.ksSession?
                .dataTaskPublisher(for: urlString)
                .tryMap { output in
                    // throw an error if response is nil
                    guard output.response is HTTPURLResponse else {
                        throw NetworkError.parsingError
                    }
                    return output.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    // return error if json decoding fails
                    NetworkError.parsingError
                }
                .eraseToAnyPublisher()
        }
}
