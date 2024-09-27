//
//  Publisher+replaceNil.swift
//
//
//  Created by Tomáš Čislák on 11/03/2024.
//

import Combine

public extension Publisher {
    func replaceNil<T>(
        with error: Failure
    ) -> AnyPublisher<T, Self.Failure> where Self.Output == T? {
        flatMap { output -> AnyPublisher<T, Self.Failure> in
            output
                .map {
                    Just($0)
                        .setFailureType(to: Failure.self)
                        .eraseToAnyPublisher()
                } ?? Fail(error: error).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    @available(iOS 14.0, *)
    func replaceNil<T, E: Error>(
        with error: E
    ) -> AnyPublisher<T, E> where Self.Output == T?, Failure == Never {
        flatMap { output -> AnyPublisher<T, E> in
            output
                .map {
                    Just($0)
                        .setFailureType(to: E.self)
                        .eraseToAnyPublisher()
                } ?? Fail(error: error).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
