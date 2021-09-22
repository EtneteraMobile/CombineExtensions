//
//  Publisher+assign.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

import Combine

public extension Publisher {
    func assign<A: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<A, Output>,
        on object: A
    ) -> AnyCancellable where Self.Failure == Never {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
