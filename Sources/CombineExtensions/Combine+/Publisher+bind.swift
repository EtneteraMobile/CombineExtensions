//
//  Publisher+bind.swift
//  CombineExtensions
//
//  Created by Tuan Tu Do on 22.09.2021.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func bind(
        to subject: PassthroughSubject<Self.Output, Self.Failure>,
        logger: @escaping (String) -> Void = { Swift.print($0) },
        in file: String = #file,
        on line: Int = #line
    ) -> AnyCancellable where Self.Failure == Never {
        sink { [weak subject] output in
            guard let subject = subject else {
                logger("Object is nil in file: \(file), on line: \(line)!")
                return
            }
            subject.send(output)
        }
    }
}
#endif
