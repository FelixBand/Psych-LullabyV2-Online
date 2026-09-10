#pragma header

uniform float time = 0.0;
uniform float prob = 0.0;
uniform float vignetteIntensity = 0.5;

float rand(vec2 value) {
    return fract(sin(dot(value, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec2 grid = vec2(0.12, 0.08);
    vec2 cell = floor(uv / grid);
    float seed = rand(cell + floor(time * 5.0));
    float active = step(1.0 - prob, seed);
    vec2 offset = vec2((rand(cell + 2.0) - 0.5) * 0.12, 0.0) * active;
    vec2 glitchUv = clamp(uv + offset, 0.0, 1.0);
    vec3 baseColor = texture2D(bitmap, uv).rgb;
    vec3 glitchColor = texture2D(bitmap, glitchUv).rgb;
    float vignette = distance(uv, vec2(0.5));
    float amount = (0.5 * sin(time * 3.14159265) + vignetteIntensity) * vignette;
    vec3 color = mix(glitchColor, baseColor, clamp(amount, 0.0, 1.0));
    gl_FragColor = vec4(color, texture2D(bitmap, uv).a);
}
