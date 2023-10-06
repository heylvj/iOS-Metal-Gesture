//
//  Shader.metal
//  EdgeApp
//
//  Created by 吕劲 on 2023/9/26.
//

#include <metal_stdlib>
#include "ShaderTypes.h"
using namespace metal;

struct TextureRasterizerData {
    float4 position [[position]];
    
    float2 texcoord;
};

vertex TextureRasterizerData
vertexShader(const uint vertexID [[vertex_id]],
                    const device TextureVertice *vertices [[buffer(0)]],
                    constant Uniforms &uniform [[buffer(1)]] )
{
    TextureRasterizerData out;
    out.position = vector_float4(0.0, 0.0, 1.0, 1.0);
    out.position.xy = vertices[vertexID].position.xy;
    out.position.xyz = out.position.xyz * uniform.transform;
    
    out.texcoord = vertices[vertexID].texcoord;
    
    return out;
}

fragment float4
fragmentShader(TextureRasterizerData in [[stage_in]],
                      texture2d<float> texture[[texture(0)]]) {
    sampler simpleSampler;
    float4 colorSample = texture.sample(simpleSampler, in.texcoord);
    return colorSample;
}

