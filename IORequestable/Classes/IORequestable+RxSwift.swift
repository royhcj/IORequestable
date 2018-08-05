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

protocol RxIORequestable {
  associatedtype Base
  associatedtype BaseOutput
  func execute() -> Observable<BaseOutput?>
}

extension Reactive: RxIORequestable where Base: IORequestable {
  typealias BaseOutput = Base.Output

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
