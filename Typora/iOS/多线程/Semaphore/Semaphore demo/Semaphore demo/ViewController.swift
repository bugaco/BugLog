//
//  ViewController.swift
//  Semaphore demo
//
//  Created by BugaCo on 2020/11/4.
//

import UIKit

class ViewController: UIViewController {
    
    let semaphore = DispatchSemaphore.init(value: 1)
    let queue = DispatchQueue(label: "com.bugaco.queue", attributes: .concurrent)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        showAlerts()
    }
    
    private func showAlerts() {
        for i in 1...3 {
            queue.async {
                self.semaphore.wait()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert - \(i)", message: nil, preferredStyle: .alert)
                    alert.addAction(.init(title: "确定", style: .default, handler: { (_) in
                        self.semaphore.signal()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

