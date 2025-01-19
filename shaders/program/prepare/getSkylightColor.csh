



layout (local_size_x = 1, local_size_y = 1) in;
const ivec3 workGroups = ivec3(1, 1, 1);

#include "/lib/atmosphere/sky/sky.glsl"

void main()
{
    int samples = 0;
    float sampleDelta = 0.4;

    for(float phi = 0.0; phi < 2.0 * PI; phi += sampleDelta){
        float cosPhi = cos(phi);
        float sinPhi = sin(phi);

        for(float theta = 0.0; theta < 0.5 * PI; theta += sampleDelta){
            float cosTheta = cos(theta);
            float sinTheta = sin(theta);

            vec3 dir = vec3(
                sinTheta * cosPhi,
                cosTheta,
                sinTheta * sinPhi
            );

            skylightColor += getSky(dir, false);
            samples++;
        }
    }

    skylightColor /= float(samples);
    skylightColor *= 2.0;

    if(lightningBoltPosition.xyz != vec3(0.0)){
        skylightColor += vec3(20.0, 20.0, 40.0);
        sunlightColor += vec3(20.0, 20.0, 40.0);
    }

    weatherFrameTimeCounter += frameTime * (wetness + thunderStrength) * 2.0;

    // skylightColor = mix(skylightColor, exp(-1.0 * 10 * skylightColor), wetness);
    // sunlightColor = mix(sunlightColor, exp(-1.0 * 10 * sunlightColor), wetness);
}