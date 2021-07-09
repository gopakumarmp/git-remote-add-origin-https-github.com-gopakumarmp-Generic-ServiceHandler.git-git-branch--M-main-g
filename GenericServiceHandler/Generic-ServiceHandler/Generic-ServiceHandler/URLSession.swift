//
//  URLSession.swift
//  Generic-ServiceHandler
//
//  Created by Gopakumar MP on 7/8/21.
//

import Foundation


enum ServiceError :Error {
    case invalidUrl
    case invalidData
}

extension URLSession {
    
    func request<T: Codable> (url: URL?, expecting: T.Type, completion: @escaping (Result<T,Error>) -> Void ) {
        
        guard let url = url else {
            completion(.failure(ServiceError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                if let error  = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(ServiceError.invalidData))
                }
                return
            }
            
            do {
                
                let result = try JSONDecoder().decode(expecting.self, from: data)
                completion(.success(result))
            }
            
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
