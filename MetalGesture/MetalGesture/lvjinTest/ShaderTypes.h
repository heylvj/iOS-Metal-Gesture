//
//  ShaderTypes.h
//  EdgeApp
//
//  Created by 吕劲 on 2023/9/28.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef struct {
    matrix_float3x3 transform;
} Uniforms;

typedef struct {
    vector_float2 position;
    vector_float2 texcoord;
} TextureVertice;

typedef enum {
    VertexInputIndexVertice = 0,
    VertexInputIndexUniform = 1
} VertexInputIndex;

typedef enum {
    TextureIndex0 = 0
} TextureInputIndex;

#endif /* ShaderTypes_h */
