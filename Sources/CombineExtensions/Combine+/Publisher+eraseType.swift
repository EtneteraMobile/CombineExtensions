//
//  Publisher+eraseType.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

import Combine

public extension Publisher {
    func eraseType() -> Publishers.Map<Self, Void> {
        map { _ in return () }
    }
}
