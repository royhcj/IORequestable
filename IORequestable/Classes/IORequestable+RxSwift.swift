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

  func execute() -> Observable<Base.Output?> {
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
  
  
}
