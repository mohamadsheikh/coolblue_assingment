//
//  NetworkService.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation

enum NetworkConfigurations {
    static let successResponseCodeRange: Range<Int> = 200 ..< 300
    static let defaultTimeout: TimeInterval = 30
}

class NetworkService {
    
    enum NetworkError: Error {
      case operationCancelled
      case requestFailed(error: Error)
      case unknownStatusCode
      case unexpectedStatusCode(code: Int)
      case contentEmptyData
      case contentDecoding(error: Error)
    }
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func makeRequest<T: Decodable>(withClient client : NetworkClient,
                                   dataType: T.Type,
                                   completion: @escaping (Result<T, Swift.Error>) -> Void) {
        print("loading data from:\(client.urlRequest.url!)")
        let task = session.dataTask(with: client.urlRequest) { [weak self] (data, response, error) in
            completion(Result<T, Swift.Error> {
              guard let self = self else {
                throw NetworkError.operationCancelled
              }

              if let requestError = error {
                throw NetworkError.requestFailed(error: requestError)
              }
              
              try self.validate(response: response, statusCodes: NetworkConfigurations.successResponseCodeRange)
              return try self.decode(data: data, type: dataType)
            })
        }
        task.resume()
        
    }
}

private extension NetworkService {
    func validate(response: URLResponse?, statusCodes: Range<Int>) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownStatusCode
        }
        
        if !statusCodes.contains(httpResponse.statusCode) {
            throw NetworkError.unexpectedStatusCode(code: httpResponse.statusCode)
        }
    }
    
    func decode<T: Decodable>(data: Data?, type: T.Type) throws -> T {
        guard let data = data, !data.isEmpty else {
            throw NetworkError.contentEmptyData
        }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw NetworkError.contentDecoding(error: error)
        }
    }
}

extension NetworkService.NetworkError: CustomStringConvertible {
  public var description: String {
    switch self {
    case .operationCancelled:
      return "Operation was cancelled"
    case let .requestFailed(error):
      return "Request failed with \(error)"
    case .unknownStatusCode:
      return "The status code is unknown"
    case let .unexpectedStatusCode(error):
      return "The status code is unexpected \(error)"
    case .contentEmptyData:
      return "The contyent data is empty"
    case let .contentDecoding(error):
      return "Error while decoding with \(error)"
    }
  }
}

