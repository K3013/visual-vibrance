/*
    Copyright (c) 2024 Josh Britain (jbritain)
    Licensed under the MIT license

      _____   __   _                          
     / ___/  / /  (_)  __ _   __ _  ___   ____
    / (_ /  / /  / /  /  ' \ /  ' \/ -_) / __/
    \___/  /_/  /_/  /_/_/_//_/_/_/\__/ /_/   
    
    By jbritain
    https://jbritain.net
                                            
*/

#ifndef WATER_FOG_GLSL
#define WATER_FOG_GLSL

#define WATER_ABSORPTION (vec3(0.3, 0.03, 0.04) * (isEyeInWater == 1 ? vec3(1.0, 0.0, 7.0) : vec3(5.0)))
#define WATER_SCATTERING (vec3(0.01, 0.04, 0.05) * (isEyeInWater == 1 ? vec3(0.5, 2.0, 0.5) : vec3(0.01)))
#define WATER_DENSITY 1.0

vec3 waterExtinction = clamp01(WATER_ABSORPTION + WATER_SCATTERING);

vec3 waterFog(vec3 color, vec3 a, vec3 b, float dhFactor){
  if(dhFactor > 0.0){
    vec3 sunTransmittance = exp(-waterExtinction * WATER_DENSITY * dhFactor);
    color.rgb *= sunTransmittance;
  }

  vec3 opticalDepth = waterExtinction * WATER_DENSITY * distance(a, b);
  vec3 transmittance = exp(-opticalDepth);


  vec3 scatter = (sunVisibilitySmooth * luminance(sunlightColor) * getMiePhase(dot(normalize(b - a), lightDir)) + EBS.y * skylightColor);
  scatter *= (1.0 - transmittance) * (WATER_SCATTERING / waterExtinction);

  transmittance.r = 0.0;
  scatter.r = 0.0;
  

  return color * transmittance + scatter;
}

vec3 waterFog(vec3 color, vec3 a, vec3 b){
  return waterFog(color, a, b, 0.0);
}

#endif