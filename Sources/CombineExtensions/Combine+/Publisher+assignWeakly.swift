//
//  Publisher+assign.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func assignWeakly<A: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<A, Output>,
        on object: A
    ) -> AnyCancellable where Self.Failure == Never {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
#endif
