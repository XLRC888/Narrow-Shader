vec3 applyWobble(vec3 position, float time, float strength) {
    float wave1 = sin(position.x * 0.5 + time * 1.5) * 0.3;
    float wave2 = sin(position.z * 0.7 + time * 1.2) * 0.2;
    float wave3 = sin((position.x + position.z) * 0.3 + time * 0.8) * 0.15;
    float totalWave = (wave1 + wave2 + wave3) * strength;
    position.y += totalWave;
    return position;
}

vec3 applyRainTilt(vec3 position, float rainStrength) {
    float tilt = rainStrength * 0.15;
    position.x += sin(position.y * 0.1) * tilt;
    position.z += cos(position.y * 0.1) * tilt;
    return position;
}

vec3 applyWaterWobble(vec3 position, float time) {
    float wave1 = sin(position.x * 2.0 + time * 2.0) * 0.05;
    float wave2 = sin(position.z * 1.5 + time * 1.5) * 0.03;
    float wave3 = cos(position.x * 1.0 + position.z * 1.0 + time * 1.0) * 0.02;
    position.y += wave1 + wave2 + wave3;
    return position;
}
