//
//  Publisher+catch.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func `catch`<A: AnyObject, P: Publisher>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        onNil: P,
        _ handler: @escaping (A, Self.Failure) -> P
    ) -> Publishers.Catch<Self, P> where Self.Output == P.Output {
        `catch` { [weak object] error in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return onNil
            }
            
            return handler(object, error)
        }
    }
    
    func `catch`<A: AnyObject, F: Error>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        onNil: F,
        _ handler: @escaping (A, Self.Failure) -> AnyPublisher<Self.Output, F>
    ) -> AnyPublisher<Self.Output, F> {
        `catch`(
            weak: object,
            logger: logger,
            in: file,
            on: line,
            onNil: Fail<Self.Output, F>(error: onNil).eraseToAnyPublisher(),
            handler
        )
        .eraseToAnyPublisher()
    }
}
#endif
