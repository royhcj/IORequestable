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
    
    iTunesAPI.SearchItems { $0.init(
        term: "Swift", limit: 10, lang: "en_us"
      ) }.execute { result in
        switch result {
        case .success(let output):
          print("Number of items found: \(output.resultCount)")
          output.results?.forEach { item in
            print("\(item.kind): \(item.trackName ?? "") (by \(item.artistName ?? "?"))")
          }
        case .failure(let error):
          print(error)
        }
      }
  }
}


