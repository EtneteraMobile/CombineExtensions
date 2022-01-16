//
//  Publisher+eraseType.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func eraseType() -> Publishers.Map<Self, Void> {
        map { _ in return () }
    }
}
#endif
