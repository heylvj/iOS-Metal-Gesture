//
//  ViewController.swift
//  MetalGesture
//
//  Created by 吕劲 on 2023/10/6.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let vc = TestMKView()
        navigationController?.pushViewController(vc, animated: false)
    }


}

