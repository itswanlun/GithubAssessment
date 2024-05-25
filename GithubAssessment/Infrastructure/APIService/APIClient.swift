//
//  APIClient.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/25.
//

import Foundation
import Combine

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private func request<DecodingType: Decodable>(_ url: URL) -> AnyPublisher<Result<DecodingType, Error>, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                let decoder = JSONDecoder()
                return try decoder.decode(DecodingType.self, from: result.data)
            }
            .map {
                .success($0)
            }
            .catch {
                Just(.failure($0))
            }
            .eraseToAnyPublisher()
    }
}

extension APIClient {
    func getRepositores(q: String, page: Int) -> AnyPublisher<Result<Repositories, Error>, Never> {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(q)&page=\(page)")!
        let apiPublisher: AnyPublisher<Result<Repositories, Error>, Never> = APIClient.shared.request(url).eraseToAnyPublisher()
        
        return apiPublisher
    }
}
