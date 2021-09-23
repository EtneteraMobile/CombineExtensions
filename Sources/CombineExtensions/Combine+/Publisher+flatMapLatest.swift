//
//  Publisher+flatMapLatest.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 23.09.2021.
//

import Combine

public extension Publisher {
    func flatMapLatest<P: Publisher>(
        _ transform: @escaping (Output) -> P
    ) -> Publishers.SwitchToLatest<P, Publishers.Map<Self, P>> {
        map(transform).switchToLatest()
    }
}
