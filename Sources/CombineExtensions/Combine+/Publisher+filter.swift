//
//  Publisher+filter.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 04.10.2021.
//

import Combine

public extension Publisher {
    func filter<A: AnyObject>(
        weak object: A,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line,
        _ isIncluded: @escaping (A, Self.Output) -> Bool
    ) -> Publishers.Filter<Self> {
        filter { [weak object] output in
            guard let object = object else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return false
            }
            
            return isIncluded(object, output)
        }
    }
}
