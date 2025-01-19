#version 430 compatibility
#include "/lib/common.glsl"

/*
    Copyright (c) 2024 Josh Britain (jbritain)
    Licensed under the MIT license

      _____   __   _                          
     / ___/  / /  (_)  __ _   __ _  ___   ____
    / (_ /  / /  / /  /  ' \ /  ' \/ -_) / __/
    \___/  /_/  /_/  /_/_/_//_/_/_/\__/ /_/   
    
    By jbritain
    https://jbritain.net
                                            
*/#define WORLD_OVERWORLD




in vec2 mc_Entity;
in vec4 at_tangent;

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;
flat out int materialID;
out vec3 viewPos;
out vec3 normal;

void main() {
    materialID = int(mc_Entity.x + 0.5);
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;

    normal = gl_NormalMatrix * gl_Normal;

    viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    viewPos += normal * 1e-3; // z fighting fix

    gl_Position = gbufferProjection * vec4(viewPos, 1.0);
}