//
//  FirstViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/14.
//

import UIKit

final class FirstViewController: UIViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "toMainView", sender: nil)
    }

    
    
    
}
