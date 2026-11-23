#pragma header

uniform float amount = 4.0;
uniform float effectTime = 0.0;

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;

    // Convert UV to centered coordinates (-1 to 1)
    vec2 ndc = uv * 2.0 - 1.0;

    // Account for the screen aspect ratio
    float aspect = openfl_TextureSize.x / openfl_TextureSize.y;
    vec2 pos = ndc * vec2(aspect, 1.0);

    // --------------------------------------------------
    // Lens distortion
    // --------------------------------------------------

    float dist = length(pos);

    // Animated lens strength
    float lens = sin(effectTime * 2.0) * 0.15;

    // Barrel/pincushion-style distortion
    vec2 distorted = pos * (1.0 + lens * dist * dist);

    // Convert back to UV
    vec2 distortedUV = distorted / vec2(aspect, 1.0);
    distortedUV = distortedUV * 0.5 + 0.5;

    // --------------------------------------------------
    // Chromatic aberration
    // --------------------------------------------------

    // Distance from the center of the screen.
    // This makes the aberration weak in the center
    // and stronger toward the edges.
    vec2 centerOffset = distortedUV - 0.5;

    float edgeStrength = dot(centerOffset, centerOffset);

    // Convert pixel amount into UV space.
    float aberration = amount / openfl_TextureSize.x;

    // Direction pointing away from the center.
    vec2 direction = normalize(centerOffset);

    // Avoid problems exactly at the center.
    if (edgeStrength < 0.000001)
        direction = vec2(1.0, 0.0);

    vec2 chromaOffset = direction * aberration * edgeStrength * 8.0;

    // --------------------------------------------------
    // RGB samples
    // --------------------------------------------------

    float red = flixel_texture2D(
        bitmap,
        distortedUV + chromaOffset
    ).r;

    float green = flixel_texture2D(
        bitmap,
        distortedUV
    ).g;

    float blue = flixel_texture2D(
        bitmap,
        distortedUV - chromaOffset
    ).b;

    float alpha = flixel_texture2D(
        bitmap,
        distortedUV
    ).a;

    gl_FragColor = vec4(red, green, blue, alpha);
}