import Combine

public extension Publisher {
	func typedTryMap<T>(
		_ transform: @escaping (Self.Output) throws -> T,
		onError: @escaping (Error) -> Self.Failure
	) -> AnyPublisher<T, Self.Failure> {
		flatMap { input -> AnyPublisher<T, Self.Failure> in
			do {
				return try .just(transform(input))
			} catch {
				return .fail(error: onError(error))
			}
		}
		.eraseToAnyPublisher()
	}
}
