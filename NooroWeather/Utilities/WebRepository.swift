//
//  WebRepository.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value: Decodable>(endpoint: APICall, httpCodes: HTTPCodes = .success) async throws(APIError) -> Value {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            let (data, response) = try await session.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }

            guard httpCodes.contains(statusCode) else {
                throw APIError.invalidStatusCode(statusCode: statusCode)
            }

            let decodedResponse = try JSONDecoder().decode(Value.self, from: data)

            return decodedResponse
        } catch let error as DecodingError {
            throw .decodingFailed(innerError: error)
        } catch let error as EncodingError {
            throw .encodingFailed(innerError: error)
        } catch let error as URLError {
            throw .requestFailed(innerError: error)
        } catch let error as APIError {
            throw error
        } catch {
            throw .otherError(innerError: error)
        }
    }
}
