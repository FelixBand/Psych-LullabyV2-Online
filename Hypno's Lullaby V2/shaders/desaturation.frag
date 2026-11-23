#pragma header

uniform float desaturationAmount = 0.0;
uniform float distortionTime = 0.0;
uniform float amplitude = -0.1;
uniform float frequency = 8.0;

void main() {
    vec2 uv = openfl_TextureCoordv.xy;

    float offset = sin((uv.y * frequency) + distortionTime) * amplitude;

    vec4 texColor = texture2D(
        bitmap,
        vec2(uv.x + offset, uv.y)
    );

    float luminance = dot(
        texColor.rgb,
        vec3(0.2126, 0.7152, 0.0722)
    );

    vec3 desaturated = vec3(luminance);

    gl_FragColor = vec4(
        mix(desaturated, texColor.rgb, desaturationAmount),
        texColor.a
    );
}