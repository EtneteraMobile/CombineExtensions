//
//  Publisher+sink.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

import Combine

public extension Publisher {
    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
    
    func sink<A: AnyObject>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        receiveCompletion: @escaping (A, Subscribers.Completion<Self.Failure>) -> Void,
        receiveValue: @escaping (A, Self.Output) -> Void
    ) -> AnyCancellable  {
        sink(
            receiveCompletion: { [weak object] completion in
                guard let object = object else {
                    logger("Object is nil in file: \(file), on line: \(line)!")
                    return
                }
                
                return receiveCompletion(object, completion)
            },
            receiveValue: { [weak object] value in
                guard let object = object else {
                    logger("Object is nil in file: \(file), on line: \(line)!")
                    return
                }
                
                return receiveValue(object, value)
            }
        )
    }
}

public extension Publisher where Failure == Never {
    func sink<A: AnyObject>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        receiveValue: @escaping (A, Self.Output) -> Void
    ) -> AnyCancellable {
        sink(
            weak: object,
            logger: logger,
            receiveCompletion: { _, _ in },
            receiveValue: receiveValue
        )
    }
}
