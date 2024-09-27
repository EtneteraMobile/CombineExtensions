//
//  File.swift
//  
//
//  Created by Tomáš Čislák on 04/09/2024.
//

import Combine
import Foundation

public extension AnyPublisher {
  static func fail(error: Failure) -> AnyPublisher<Output, Failure> {
    Fail(error: error)
      .eraseToAnyPublisher()
  }
}
