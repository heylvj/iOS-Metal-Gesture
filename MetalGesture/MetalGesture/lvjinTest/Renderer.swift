//
//  Renderer.swift
//  EdgeApp
//
//  Created by 吕劲 on 2023/9/26.
//

import Foundation
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {
    
    var transform: CGAffineTransform = .identity
    
    var scale: CGPoint = CGPoint(x: 1.0, y: 0.5) {
        didSet {
            transform.a = scale.x
            transform.d = scale.y
        }
    }
    var translate: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            transform.tx = translate.x
            transform.ty = translate.y
        }
    }
    
    var _viewProportion: CGFloat = 1.0
    var _viewSize: CGSize = .zero
    
    var _baseScale: CGPoint = CGPoint(x: 1.0, y: 1.0)
    var _baseTranslate: CGPoint = .zero
    
    var contentProportion: CGFloat = 1.0
    var contentSize: CGSize = .zero
    
    
    var _mtkView: MTKView
    var _device: MTLDevice?
    var _commandQueue: MTLCommandQueue?
    var _pipelineState: MTLRenderPipelineState?
    var _texture: MTLTexture?
    
    var _vertices: MTLBuffer?
    var _numberVertices: Int
    
    init(with mktView: MTKView) {
        _mtkView = mktView
        _device = _mtkView.device
        _commandQueue = _device?.makeCommandQueue()
        
        let defaultLib = _device?.makeDefaultLibrary()
        let vertexFunction = defaultLib?.makeFunction(name: "vertexShader")
        let fragmentFunction = defaultLib?.makeFunction(name: "fragmentShader")
        
        let renderPipelineDescript = MTLRenderPipelineDescriptor()
        renderPipelineDescript.label = "RenderPipeline"
        renderPipelineDescript.vertexFunction = vertexFunction
        renderPipelineDescript.fragmentFunction = fragmentFunction
        renderPipelineDescript.colorAttachments[0].pixelFormat = mktView.colorPixelFormat
        
        do {
            _pipelineState = try _device?.makeRenderPipelineState(descriptor: renderPipelineDescript)
        } catch {
            print("gen pipeline state error \(error)")
        }
        
        let vertices: [TextureVertice] = [TextureVertice(position: [1.0, -1.0], texcoord: [1.0, 1.0]),
                                          TextureVertice(position: [-1.0, -1.0], texcoord: [0.0, 1.0]),
                                          TextureVertice(position: [-1.0, 1.0], texcoord: [0.0, 0.0]),
                                          TextureVertice(position: [1.0, -1.0], texcoord: [1.0, 1.0]),
                                          TextureVertice(position: [-1.0, 1.0], texcoord: [0.0, 0.0]),
                                          TextureVertice(position: [1.0, 1.0], texcoord: [1.0, 0.0])]
        
        _vertices = _device?.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size * 4, options: MTLResourceOptions.storageModeShared)
        _numberVertices = vertices.count
        
        super.init()
        self.addGesture()
        self.loadTexture()
    }
    
    /// load texture from image
    func loadTexture() {
        let image = UIImage(named: "test1.png")!
        let loader = MTKTextureLoader(device: _device!)
        do {
            _texture = try loader.newTexture(cgImage: image.cgImage!)
        } catch {
            print("Load texture fail \(error)")
        }
        contentProportion = image.size.width / image.size.height
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        _viewSize.width = size.width
        _viewSize.height = size.height
        
        _viewProportion = size.width / size.height
        if _viewProportion > contentProportion {
            // height = 1.0
            contentSize = CGSize(width: size.height * contentProportion, height: size.height)
            _baseScale = CGPoint(x: contentSize.width / _viewSize.width, y: 1.0)
        } else {
            // widht = 1.0
            contentSize = CGSize(width: size.width, height: size.width / contentProportion)
            _baseScale = CGPoint(x: 1.0, y: contentSize.height / _viewSize.height)
        }
        
        scale = _baseScale
    }
    
    func draw(in view: MTKView) {
        guard let renderPassDescript = view.currentRenderPassDescriptor else {
            print("renderPassDescript is nil")
            return
        }
        guard let commandBuffer = _commandQueue?.makeCommandBuffer() else {
            print("commandBuffer is nil")
            return
        }
        guard let _pipelineState else {
            print("_pipelineState is nil")
            return
        }
        
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescript) else {
            print("encoder is nil")
            return
        }
        
        let transform = simd_float3x3(simd_float3(Float(transform.a), 0.0, Float(transform.tx)),
                                      simd_float3(0.0, Float(transform.d), Float(transform.ty)),
                                      simd_float3(0.0, 0.0, 1.0))
        
        var uniform = Uniforms(transform: transform)
        
        encoder.setRenderPipelineState(_pipelineState)
        encoder.setVertexBuffer(_vertices, offset: 0, index: 0)
        
        encoder.setVertexBytes(&uniform, length: MemoryLayout<Uniforms>.size, index: 1)
        encoder.setFragmentTexture(_texture, index: 0)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: _numberVertices)
        encoder.endEncoding()
        
        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }
        
        commandBuffer.commit()
    }
}
