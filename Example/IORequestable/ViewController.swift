//
//  ViewController.swift
//  IORequestable
//
//  Created by royhcj on 08/04/2018.
//  Copyright (c) 2018 royhcj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.text = "Tap on an API to call."
  }
  
  @IBAction func clickedITunesSearchItems(_ sender: Any) {
    
    iTunesAPI.SearchItems { $0.init(
        term: "Swift", limit: 10, lang: "en_us"
      ) }.execute { result in
        var resultText = ""
        
        switch result {
        case .success(let output):
          resultText += "Number of items found: \(output.resultCount)\n"
          output.results?.forEach { item in
            resultText += "\(item.kind): \(item.trackName ?? "") (by \(item.artistName ?? "?"))\n"
          }
        case .failure(let error):
          resultText = error.localizedDescription
        }
        
        self.textView.text = resultText
      }
  }
}


