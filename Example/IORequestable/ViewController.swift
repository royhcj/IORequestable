//
//  ViewController.swift
//  IORequestable
//
//  Created by royhcj on 08/04/2018.
//  Copyright (c) 2018 royhcj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    GithubAPI.GetSearchRecords {
        $0.init(user: "royhcj")
      }.execute { result in
        switch result {
          case .success(let data):
            print(type(of: data))
          case .failure(let error):
            print(error)
        }
      }
  }
}


