//
//  APICall.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation

protocol APICall {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }

    func body() throws -> Data?
}

enum APIError: Error {
    case invalidURL
    case encodingFailed(innerError: EncodingError)
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case unexpectedResponse
    case otherError(innerError: Error)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .encodingFailed: return "Failed to encode JSON"
        case .decodingFailed: return "Failed to decode JSON"
        case .requestFailed: return "Request failed"
        case let .invalidStatusCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .otherError: return "An unknown error occurred"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()

        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
