//
//  ObservableConvertibleType+Driver.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 9/19/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift

extension ObservableConvertibleType {
    /**
    Converts observable sequence to `Driver` trait.
    
    - parameter onErrorJustReturn: Element to return in case of error and after that complete the sequence.
    - returns: Driver trait.
    */
    public func asDriver(onErrorJustReturn: Element) -> Driver<Element> {
        let source = self
            .asObservable()
            .observe(on:DriverSharingStrategy.scheduler) // 主线程监听
            .catchAndReturn(onErrorJustReturn) // 无法产生错误
        return Driver(source)
    }
    
    /**
    Converts observable sequence to `Driver` trait.
    
    - parameter onErrorDriveWith: Driver that continues to drive the sequence in case of error.
    - returns: Driver trait.
    */
    public func asDriver(onErrorDriveWith: Driver<Element>) -> Driver<Element> {
        let source = self
            .asObservable()
            .observe(on:DriverSharingStrategy.scheduler)
            .catch { _ in
                onErrorDriveWith.asObservable()
            }
        return Driver(source)
    }

    /**
    Converts observable sequence to `Driver` trait.
    
    - parameter onErrorRecover: Calculates driver that continues to drive the sequence in case of error.
    - returns: Driver trait.
    */
    public func asDriver(onErrorRecover: @escaping (_ error: Swift.Error) -> Driver<Element>) -> Driver<Element> {
        let source = self
            .asObservable()
            .observe(on:DriverSharingStrategy.scheduler)
            .catch { error in
                onErrorRecover(error).asObservable()
            }
        return Driver(source)
    }
}
