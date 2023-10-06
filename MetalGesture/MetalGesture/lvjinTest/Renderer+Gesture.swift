//
//  Renderer+TransformExtension.swift
//  BuouCamera
//
//  Created by 吕劲 on 2023/10/6.
//

import Foundation
import MetalKit

extension Renderer {
    func addTranslate(_ translate: CGPoint = .zero) {
        self.translate = self.translate + translate
    }
    
    func addScale(_ scale: CGFloat, anchor: CGPoint) {
        self.scale = self.scale * scale
        let offset = (translate - anchor) * (scale - 1.0)
        self.translate = self.translate + offset
    }
    
    func resetTransform() {
        scale = _baseScale
        translate = _baseTranslate
    }
}

extension Renderer: UIGestureRecognizerDelegate {
    
    func addGesture() {
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(pan(sender: )))
        _mtkView.addGestureRecognizer(panGes)
        let pinGes = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender: )))
        _mtkView.addGestureRecognizer(pinGes)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(doubleTap(sender: )))
        tapGes.numberOfTapsRequired = 2
        _mtkView.addGestureRecognizer(tapGes)
        panGes.delegate = self
        pinGes.delegate = self
    }
    
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: _mtkView) * CGPoint(x: 1.0, y: -1.0)
        let normalTranslate = translate / _viewSize * 2
        addTranslate(normalTranslate)
        sender.setTranslation(.zero, in: _mtkView)
    }
     
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        sender.scale = 1.0
        
        let point = sender.location(in: _mtkView)
        let center = CGPoint(x: _viewSize.width * 0.5, y: _viewSize.height * 0.5)
        var offset = point - center
        offset = offset * CGPoint(x: 1.0, y: -1.0)
        let normalOffset = offset / contentSize
        addScale(scale, anchor: normalOffset)
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        resetTransform()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
