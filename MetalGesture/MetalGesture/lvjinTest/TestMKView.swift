//
//  TestMKView.swift
//  EdgeApp
//
//  Created by 吕劲 on 2023/9/25.
//

import UIKit
import MetalKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class TestMKView: UIViewController, UIGestureRecognizerDelegate {

    var mtkView: MTKView!
    
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let w = screenWidth
        let h = screenHeight * 0.5
        let frame = CGRect(x: 0, y: 0.5 * (screenHeight - h), width: w, height: h)
        
        mtkView = MTKView(frame: frame)
        view.addSubview(mtkView)
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.clearColor = MTLClearColor(red: 0.3, green: 0.3, blue: 0.5, alpha: 1.0)
        
        renderer = Renderer(with: mtkView)
        mtkView.delegate = renderer
        renderer.mtkView(mtkView, drawableSizeWillChange: frame.size)
    }
}
