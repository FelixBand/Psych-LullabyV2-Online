#pragma header

uniform float time;
uniform float prob;
uniform float vignetteIntensity;

#define PI 3.14159265359

const float glitchScale = 0.5;

// --------------------------------------------------------
// Helpers
// --------------------------------------------------------

float _round(float n)
{
    return floor(n + 0.5);
}

vec2 _round(vec2 n)
{
    return floor(n + 0.5);
}

float rand(vec2 co)
{
    return fract(
        sin(dot(co, vec2(12.9898, 78.233))) *
        43758.5453
    );
}

vec2 glitchCoord(vec2 p, vec2 gridSize)
{
    vec2 coord = floor(p / gridSize) * gridSize;
    coord += gridSize * 0.5;
    return coord;
}

// --------------------------------------------------------
// Glitch seed
// --------------------------------------------------------

struct GlitchSeed
{
    vec2 seed;
    float prob;
};

GlitchSeed glitchSeed(vec2 p, float speed)
{
    /*
     * Deliberately quantized so the glitch changes in
     * discrete chunks rather than smoothly sliding.
     */
    float seedTime = floor(time * speed);

    GlitchSeed result;

    result.seed = vec2(
        1.0 + mod(seedTime / 100.0, 100.0),
        1.0 + mod(seedTime, 100.0)
    ) / 100.0;

    result.seed += p;
    result.prob = prob;

    return result;
}

float shouldApply(GlitchSeed seed)
{
    float value = mix(
        mix(
            rand(seed.seed),
            1.0,
            clamp(seed.prob - 0.5, 0.0, 1.0)
        ),
        0.0,
        clamp((1.0 - seed.prob) * 0.5, 0.0, 1.0)
    );

    return _round(value);
}

// --------------------------------------------------------
// Block swapping
// --------------------------------------------------------

vec4 swapCoords(
    vec2 seed,
    vec2 groupSize,
    vec2 subGrid,
    vec2 blockSize
)
{
    vec2 rand2 = vec2(
        rand(seed),
        rand(seed + vec2(0.1))
    );

    vec2 range = subGrid - (blockSize - 1.0);

    vec2 coord =
        floor(rand2 * range) / subGrid;

    vec2 bottomLeft =
        coord * groupSize;

    vec2 realBlockSize =
        (groupSize / subGrid) * blockSize;

    vec2 topRight =
        bottomLeft + realBlockSize;

    topRight -= groupSize * 0.5;
    bottomLeft -= groupSize * 0.5;

    return vec4(
        bottomLeft,
        topRight
    );
}

float isInBlock(vec2 pos, vec4 block)
{
    vec2 a = sign(pos - block.xy);
    vec2 b = sign(block.zw - pos);

    return min(
        sign(a.x + a.y + b.x + b.y - 3.0),
        0.0
    );
}

vec2 moveDiff(
    vec2 pos,
    vec4 swapA,
    vec4 swapB
)
{
    vec2 diff =
        swapB.xy - swapA.xy;

    return diff * isInBlock(pos, swapA);
}

void swapBlocks(
    inout vec2 xy,
    vec2 groupSize,
    vec2 subGrid,
    vec2 blockSize,
    vec2 seed,
    float apply
)
{
    vec2 groupOffset =
        glitchCoord(xy, groupSize);

    vec2 pos =
        xy - groupOffset;

    vec2 seedA =
        seed * groupOffset;

    vec2 seedB =
        seed * (groupOffset + vec2(0.1));

    vec4 swapA =
        swapCoords(
            seedA,
            groupSize,
            subGrid,
            blockSize
        );

    vec4 swapB =
        swapCoords(
            seedB,
            groupSize,
            subGrid,
            blockSize
        );

    vec2 newPos = pos;

    newPos +=
        moveDiff(pos, swapA, swapB) * apply;

    newPos +=
        moveDiff(pos, swapB, swapA) * apply;

    xy =
        newPos + groupOffset;
}

// --------------------------------------------------------
// Static
// --------------------------------------------------------

void staticNoise(
    inout vec2 p,
    vec2 groupSize,
    float grainSize,
    float contrast
)
{
    GlitchSeed seedA =
        glitchSeed(
            glitchCoord(p, groupSize),
            5.0
        );

    seedA.prob *= 0.5;

    if (shouldApply(seedA) == 1.0)
    {
        GlitchSeed seedB =
            glitchSeed(
                glitchCoord(
                    p,
                    vec2(grainSize)
                ),
                5.0
            );

        vec2 offset = vec2(
            rand(seedB.seed),
            rand(seedB.seed + vec2(0.1))
        );

        offset =
            _round(offset * 2.0 - 1.0);

        offset *= contrast;

        p += offset;
    }
}

// --------------------------------------------------------
// Glitch composition
// --------------------------------------------------------

void glitchSwap(inout vec2 p)
{
    float scale = glitchScale;
    float speed = 5.0;

    vec2 groupSize;
    vec2 subGrid;
    vec2 blockSize;

    GlitchSeed seed;
    float apply;

    // Large blocks
    groupSize = vec2(0.6) * scale;
    subGrid = vec2(2.0);
    blockSize = vec2(1.0);

    seed =
        glitchSeed(
            glitchCoord(p, groupSize),
            speed
        );

    apply =
        shouldApply(seed);

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed,
        apply
    );

    // Medium blocks
    groupSize = vec2(0.8) * scale;
    subGrid = vec2(3.0);
    blockSize = vec2(1.0);

    seed =
        glitchSeed(
            glitchCoord(p, groupSize),
            speed
        );

    apply =
        shouldApply(seed);

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed,
        apply
    );

    // Small blocks
    groupSize = vec2(0.2) * scale;
    subGrid = vec2(6.0);
    blockSize = vec2(1.0);

    seed =
        glitchSeed(
            glitchCoord(p, groupSize),
            speed
        );

    float apply2 =
        shouldApply(seed);

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + vec2(1.0),
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + vec2(2.0),
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + vec2(3.0),
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + vec2(4.0),
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + vec2(5.0),
        apply * apply2
    );

    // Horizontal glitch bars
    groupSize = vec2(1.2, 0.2) * scale;
    subGrid = vec2(9.0, 2.0);
    blockSize = vec2(3.0, 1.0);

    seed =
        glitchSeed(
            glitchCoord(p, groupSize),
            speed
        );

    apply =
        shouldApply(seed);

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed,
        apply
    );
}

void glitchStatic(inout vec2 p)
{
    staticNoise(
        p,
        vec2(0.5, 0.125) * glitchScale,
        0.2 * glitchScale,
        2.0
    );
}

// --------------------------------------------------------
// Main
// --------------------------------------------------------

void main()
{
    vec2 uv =
        openfl_TextureCoordv.xy;

    vec4 base =
        flixel_texture2D(bitmap, uv);

    vec2 p = uv;

    glitchSwap(p);
    glitchStatic(p);

    vec4 distorted =
        flixel_texture2D(bitmap, p);

    float amount =
        0.5 * sin(time * PI) +
        vignetteIntensity;

    float vignette =
        distance(
            uv,
            vec2(0.5)
        );

    vignette =
        mix(
            1.0,
            1.0 - amount,
            vignette
        );

    vec3 color =
        mix(
            distorted.rgb,
            base.rgb,
            vignette
        );

    gl_FragColor =
        vec4(color, base.a);
}