//
//  File.swift
//
//
//  Created by Tomáš Čislák on 12/08/2024.
//

import Combine

public extension AnyPublisher {
    static func publisher<T>(
        _ transform: @escaping () async throws -> T
    ) -> AnyPublisher<T, Error> {
        Future { promise in
            Task {
                do {
                    let output = try await transform()
                    promise(.success(output))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    static func publisher<T>(
        _ transform: @escaping () async -> T
    ) -> AnyPublisher<T, Never> {
        Future { promise in
            Task {
                let output = await transform()
                promise(.success(output))
            }
        }
        .eraseToAnyPublisher()
    }
}
