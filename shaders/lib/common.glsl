

#ifndef COMMON_GLSL
#define COMMON_GLSL

#include "/lib/common/settings.glsl"

#include "/lib/common/debug.glsl"

#include "/lib/common/syntax.glsl"
#include "/lib/common/uniforms.glsl"
#include "/lib/common/util.glsl"

#include "/lib/common/material.glsl"
#include "/lib/common/spaceConversions.glsl"
#include "/lib/common/materialIDs.glsl"

const float wetnessHalflife = 50.0;
const float drynessHalflife = 25.0;

vec3 sunDir = normalize(sunPosition);
vec3 worldSunDir = mat3(gbufferModelViewInverse) * sunDir;

vec3 lightDir = normalize(shadowLightPosition);
vec3 worldLightDir = mat3(gbufferModelViewInverse) * lightDir;

bool isDay = sunDir == lightDir;
#define isNight !isDay

layout(std430, binding = 0) buffer environmentData {
    vec3 sunlightColor;
    vec3 skylightColor;
    float weatherFrameTimeCounter; // only increments when it is raining
};

layout(std430, binding = 1) buffer smoothedData {
    float sunVisibilitySmooth;
};

#define weatherSunlightColor mix(sunlightColor, sunlightColor * 0.005, pow(wetness, rcp(5.0)))
#define weatherSkylightColor mix(skylightColor, sunlightColor * 0.02, pow(wetness, rcp(5.0)))

const bool colortex3Clear = false;

// BUFFER FORMATS
/*
    const int colortex0Format = RGB16F;
*/

#ifdef BLOOM
/*
    const int colortex2Format = RGB16F;
*/
#endif

#ifdef TEMPORAL_FILTER
/*
    const int colortex3Format = RGB16F;
*/
#endif

#ifdef INFINITE_OCEAN
#endif

#endif // COMMON_GLSL