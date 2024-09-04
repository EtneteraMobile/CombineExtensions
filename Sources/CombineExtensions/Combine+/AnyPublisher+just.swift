//
//  File.swift
//  
//
//  Created by Tomáš Čislák on 04/09/2024.
//

import Combine

public extension AnyPublisher {
  static func just<E: Error>(_ value: Output) -> AnyPublisher<Output, E> {
    Just(value)
      .setFailureType(to: E.self)
      .eraseToAnyPublisher()
  }
}

