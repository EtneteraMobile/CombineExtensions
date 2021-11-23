//
//  Publisher+flatMap.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

import Combine

public extension Publisher {
    func flatMap<A: AnyObject, P: Publisher>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        onNil: P,
        _ transform: @escaping (A, Self.Output) -> P
    ) -> Publishers.FlatMap<P, Self> where Self.Failure == P.Failure {
        flatMap { [weak object] element -> P in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return onNil
            }

            return transform(object, element)
        }
    }
    
    func flatMap<A: AnyObject, Output>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        onNil error: Self.Failure,
        _ transform: @escaping (A, Self.Output) -> AnyPublisher<Output, Self.Failure>
    ) -> AnyPublisher<Output, Self.Failure> {
        flatMap(
            weak: object,
            logger: logger,
            in: file,
            on: line,
            onNil: Fail<Output, Self.Failure>(error: error).eraseToAnyPublisher(),
            transform
        )
        .eraseToAnyPublisher()
    }

    func flatMap<A: AnyObject, Output>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        _ transform: @escaping (A, Self.Output) -> AnyPublisher<Output, Self.Failure>
    ) -> AnyPublisher<Output, Self.Failure> where Self.Failure == Never {
        flatMap { [weak object] element -> AnyPublisher<Output, Self.Failure> in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }

            return transform(object, element)
        }
        .eraseToAnyPublisher()
    }
}
