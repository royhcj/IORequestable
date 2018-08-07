//
//  IORequestable+RxSwift.swift
//  Dishrank
//
//  Created by Roy Hu on 2018/8/1.
//

import Foundation
import Result
import RxSwift
import RxCocoa
import Moya

extension Reactive where Base: IORequestable {

  func ior_execute() -> Observable<Result<Base.Output, Base.ErrorT>> {
    return Observable<Result<Base.Output, Base.ErrorT>>.create { (observer) -> Disposable in
      self.base.execute { result in
        observer.onNext(result)
      }
      return Disposables.create()
    }
    .catchError({ error -> Observable<Result<Base.Output, Base.ErrorT>> in
      let result = Result<Base.Output, Base.ErrorT>.init(error: error as! Base.ErrorT)
      return Observable.just(result)
    })
  }
  
  func ior_executeJust() -> Observable<Base.Output?> {
    return Observable<Base.Output?>.create { (observer) -> Disposable in
      self.base.execute { result in
        switch result {
        case .success(let output):
          observer.onNext(output)
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
    .catchErrorJustReturn(nil)
  }
  
}

public protocol RxIORequestable: IORequestable {
  func rx_execute() -> Observable<Result<Output, ErrorT>>
  func rx_executeJust() -> Observable<Output?>
}

extension RxIORequestable {
  public func rx_execute() -> Observable<Result<Output, ErrorT>> {
    return Observable<Result<Output, ErrorT>>.create { (observer) -> Disposable in
      self.execute { result in
        observer.onNext(result)
      }
      return Disposables.create()
    }
    .catchError({ (error) -> Observable<Result<Output, ErrorT>> in
      let result = Result<Output, ErrorT>.init(error: error as! ErrorT)
      return Observable<Result<Output, ErrorT>>.just(result)
    })
  }
  
  public func rx_executeJust() -> Observable<Output?> {
    return rx_execute().map { result -> Output? in
      if case .success(let output) = result {
        return output
      }
      return nil
    }
  }
  
}
