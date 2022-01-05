//
//  EffectPublisher.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 05/01/2022.
//

import Combine
import ComposableArchitecture

extension Publisher {
    
    public func catchToEffectOnMain<T>(
        _ transform: @escaping (Result<Output, Failure>) -> T
    ) -> Effect<T, Never> {
        self
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .map { transform(.success($0)) }
            .catch { Just(transform(.failure($0))) }
            .eraseToEffect()
    }
}
