#pragma header

/*
 *
 * Sources!
 * https://www.shadertoy.com/view/ttlfzj
 *
 */

uniform float interpolation = 0.5;

const float threshold = 0.125;

// Game Boy palette
const vec3 GB0 = vec3(8.0, 24.0, 32.0) / 255.0;
const vec3 GB1 = vec3(52.0, 104.0, 86.0) / 255.0;
const vec3 GB2 = vec3(136.0, 192.0, 112.0) / 255.0;
const vec3 GB3 = vec3(224.0, 248.0, 208.0) / 255.0;

vec3 tex2D(vec2 p)
{
    vec3 col = texture2D(bitmap, p).xyz;

    if (abs(p.x - 0.5) > 0.5)
        col = vec3(0.1);

    return col;
}

float colorDistance(vec3 a, vec3 b)
{
    return distance(a, b);
}

vec3 closest_gb(vec3 color)
{
    vec3 result = GB0;
    float best = colorDistance(color, GB0);

    float d = colorDistance(color, GB1);
    if (d < best)
    {
        best = d;
        result = GB1;
    }

    d = colorDistance(color, GB2);
    if (d < best)
    {
        best = d;
        result = GB2;
    }

    d = colorDistance(color, GB3);
    if (d < best)
    {
        result = GB3;
    }

    return result;
}

void getClosestTwo(
    vec3 color,
    out vec3 firstColor,
    out vec3 secondColor,
    out float firstDistance,
    out float secondDistance
)
{
    firstColor = GB0;
    secondColor = GB1;

    firstDistance = colorDistance(color, GB0);
    secondDistance = colorDistance(color, GB1);

    float d;

    d = colorDistance(color, GB2);

    if (d < firstDistance)
    {
        secondDistance = firstDistance;
        secondColor = firstColor;

        firstDistance = d;
        firstColor = GB2;
    }
    else if (d < secondDistance)
    {
        secondDistance = d;
        secondColor = GB2;
    }

    d = colorDistance(color, GB3);

    if (d < firstDistance)
    {
        secondDistance = firstDistance;
        secondColor = firstColor;

        firstDistance = d;
        firstColor = GB3;
    }
    else if (d < secondDistance)
    {
        secondDistance = d;
        secondColor = GB3;
    }
}

bool needs_dither(vec3 color)
{
    vec3 firstColor;
    vec3 secondColor;
    float firstDistance;
    float secondDistance;

    getClosestTwo(
        color,
        firstColor,
        secondColor,
        firstDistance,
        secondDistance
    );

    return abs(firstDistance - secondDistance) <= threshold;
}

vec3 return_gbColor(vec3 sampleColor)
{
    vec3 firstColor;
    vec3 secondColor;
    float firstDistance;
    float secondDistance;

    getClosestTwo(
        sampleColor,
        firstColor,
        secondColor,
        firstDistance,
        secondDistance
    );

    if (needs_dither(sampleColor))
    {
        // 2x2 Game Boy dithering pattern.
        //
        // Use integer-ish pixel coordinates instead of trying
        // to use floating point texture coordinates as array indices.

        vec2 pixel = openfl_TextureCoordv * openfl_TextureSize;
        int x = int(mod(floor(pixel.x), 2.0));
        int y = int(mod(floor(pixel.y), 2.0));

        // Pattern:
        // 0 1
        // 1 0
        bool useSecond = (x != y);

        if (useSecond)
            return secondColor;
        else
            return firstColor;
    }

    return closest_gb(tex2D(openfl_TextureCoordv));
}

const vec3 buried_eye_color =
    vec3(255.0, 0.0, 0.0) / 255.0;

const vec3 buried_grave_color =
    vec3(121.0, 133.0, 142.0) / 255.0;

void main()
{
    vec4 color = texture2D(bitmap, openfl_TextureCoordv);

    if (color.a <= 0.0)
    {
        gl_FragColor = vec4(0.0);
        return;
    }

    vec3 colorA = color.rgb;
    vec3 colorB = return_gbColor(colorA);

    // Keep these special colors mapped to GB2.
    if (distance(colorA, buried_eye_color) < 0.001)
        colorB = GB2;

    if (distance(colorA, buried_grave_color) < 0.001)
        colorB = GB2;

    vec3 newColor = mix(colorA, colorB, interpolation);

    gl_FragColor = vec4(newColor, color.a);
}