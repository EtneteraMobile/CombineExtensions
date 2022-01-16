//
//  Publisher+flatMap.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Self.Failure == Never {
    func flatMap<A: AnyObject, Output>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        completeOnNil: Bool = true,
        _ transform: @escaping (A, Self.Output) -> AnyPublisher<Output, Self.Failure>
    ) -> AnyPublisher<Output, Self.Failure> {
        flatMap { [weak object] element -> AnyPublisher<Output, Self.Failure> in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)! Function: \(#function)")
                return Empty(completeImmediately: completeOnNil).eraseToAnyPublisher()
            }

            return transform(object, element)
        }
        .eraseToAnyPublisher()
    }

    func flatMap<A: AnyObject, B: AnyObject, Output>(
        weak objectA: A,
        weak objectB: B,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        completeOnNil: Bool = true,
        _ transform: @escaping (A, B, Self.Output) -> AnyPublisher<Output, Self.Failure>
    ) -> AnyPublisher<Output, Self.Failure> {
        flatMap { [weak objectA, weak objectB] element -> AnyPublisher<Output, Self.Failure> in
            guard
                let objectA = objectA,
                let objectB = objectB
            else {
                logger("Object is nil in file: \(file), on line: \(line)! Function: \(#function)")
                return Empty(completeImmediately: completeOnNil).eraseToAnyPublisher()
            }

            return transform(objectA, objectB, element)
        }
        .eraseToAnyPublisher()
    }
}
#endif
