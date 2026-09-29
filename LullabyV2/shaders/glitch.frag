#pragma header

uniform float time = 0.0;
uniform float prob = 0.0;
uniform float intensityChromatic = 0.0;

const int sampleCount = 50;

#define PI 3.14159265359
#define PHI 1.618033988749895

// --------------------------------------------------------
// Utility
// --------------------------------------------------------

float _round(float n) {
    return floor(n + 0.5);
}

vec2 _round(vec2 n) {
    return floor(n + 0.5);
}

vec3 tex2D(sampler2D tex, vec2 p) {
    vec3 col = flixel_texture2D(tex, p).xyz;

    if (0.5 < abs(p.x - 0.5)) {
        col = vec3(0.1);
    }

    return col;
}

// --------------------------------------------------------
// Random
// --------------------------------------------------------

float rand(vec2 co) {
    return fract(
        sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453
    );
}

const float glitchScale = 0.4;

vec2 glitchCoord(vec2 p, vec2 gridSize) {
    vec2 coord = floor(p / gridSize) * gridSize;
    coord += gridSize * 0.5;
    return coord;
}

// --------------------------------------------------------
// Glitch seed
// --------------------------------------------------------

struct GlitchSeed {
    vec2 seed;
    float prob;
};

float fBox2d(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

GlitchSeed glitchSeed(vec2 p, float speed) {
    float seedTime = floor(time * speed);

    vec2 seed = vec2(
        1.0 + mod(seedTime / 100.0, 100.0),
        1.0 + mod(seedTime, 100.0)
    ) / 100.0;

    seed += p;

    GlitchSeed result;
    result.seed = seed;
    result.prob = prob;

    return result;
}

float shouldApply(GlitchSeed seed) {
    float value = mix(
        mix(
            rand(seed.seed),
            1.0,
            seed.prob - 0.5
        ),
        0.0,
        (1.0 - seed.prob) * 0.5
    );

    return floor(value + 0.5);
}

// --------------------------------------------------------
// Gamma
// --------------------------------------------------------

const float GAMMA = 1.0;

vec3 gamma(vec3 color, float g) {
    return pow(color, vec3(g));
}

vec3 linearToScreen(vec3 linearRGB) {
    return gamma(linearRGB, 1.0 / GAMMA);
}

// --------------------------------------------------------
// Swap
// --------------------------------------------------------

vec4 swapCoords(
    vec2 seed,
    vec2 groupSize,
    vec2 subGrid,
    vec2 blockSize
) {
    vec2 rand2 = vec2(
        rand(seed),
        rand(seed + 0.1)
    );

    vec2 range = subGrid - (blockSize - 1.0);
    vec2 coord = floor(rand2 * range) / subGrid;

    vec2 bottomLeft = coord * groupSize;
    vec2 realBlockSize = (groupSize / subGrid) * blockSize;
    vec2 topRight = bottomLeft + realBlockSize;

    topRight -= groupSize * 0.5;
    bottomLeft -= groupSize * 0.5;

    return vec4(bottomLeft, topRight);
}

float isInBlock(vec2 pos, vec4 block) {
    vec2 a = sign(pos - block.xy);
    vec2 b = sign(block.zw - pos);

    return min(
        sign(a.x + a.y + b.x + b.y - 3.0),
        0.0
    );
}

vec2 moveDiff(vec2 pos, vec4 swapA, vec4 swapB) {
    vec2 diff = swapB.xy - swapA.xy;
    return diff * isInBlock(pos, swapA);
}

void swapBlocks(
    inout vec2 xy,
    vec2 groupSize,
    vec2 subGrid,
    vec2 blockSize,
    vec2 seed,
    float apply
) {
    vec2 groupOffset = glitchCoord(xy, groupSize);
    vec2 pos = xy - groupOffset;

    vec2 seedA = seed * groupOffset;
    vec2 seedB = seed * (groupOffset + 0.1);

    vec4 swapA = swapCoords(
        seedA,
        groupSize,
        subGrid,
        blockSize
    );

    vec4 swapB = swapCoords(
        seedB,
        groupSize,
        subGrid,
        blockSize
    );

    vec2 newPos = pos;

    newPos += moveDiff(pos, swapA, swapB) * apply;
    newPos += moveDiff(pos, swapB, swapA) * apply;

    xy = newPos + groupOffset;
}

// --------------------------------------------------------
// Static
// --------------------------------------------------------

void staticNoise(
    inout vec2 p,
    vec2 groupSize,
    float grainSize,
    float contrast
) {
    GlitchSeed seedA = glitchSeed(
        glitchCoord(p, groupSize),
        5.0
    );

    seedA.prob *= 0.5;

    if (shouldApply(seedA) == 1.0) {
        GlitchSeed seedB = glitchSeed(
            glitchCoord(p, vec2(grainSize)),
            5.0
        );

        vec2 offset = vec2(
            rand(seedB.seed),
            rand(seedB.seed + 0.1)
        );

        offset = floor(offset * 2.0 + 0.5) - 1.0;
        offset *= contrast;

        p += offset;
    }
}

// --------------------------------------------------------
// Freeze time
// --------------------------------------------------------

void freezeTime(
    vec2 p,
    inout float currentTime,
    vec2 groupSize,
    float speed
) {
    GlitchSeed seed = glitchSeed(
        glitchCoord(p, groupSize),
        speed
    );

    if (shouldApply(seed) == 1.0) {
        currentTime = floor(currentTime * speed) / speed;
    }
}

// --------------------------------------------------------
// Glitch compositions
// --------------------------------------------------------

void glitchSwap(inout vec2 p) {

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

    seed = glitchSeed(
        glitchCoord(p, groupSize),
        speed
    );

    apply = shouldApply(seed);

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

    seed = glitchSeed(
        glitchCoord(p, groupSize),
        speed
    );

    apply = shouldApply(seed);

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

    seed = glitchSeed(
        glitchCoord(p, groupSize),
        speed
    );

    float apply2 = shouldApply(seed);

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + 1.0,
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + 2.0,
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + 3.0,
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + 4.0,
        apply * apply2
    );

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed + 5.0,
        apply * apply2
    );

    // Horizontal blocks
    groupSize = vec2(1.2, 0.2) * scale;
    subGrid = vec2(9.0, 2.0);
    blockSize = vec2(3.0, 1.0);

    seed = glitchSeed(
        glitchCoord(p, groupSize),
        speed
    );

    apply = shouldApply(seed);

    swapBlocks(
        p,
        groupSize,
        subGrid,
        blockSize,
        seed.seed,
        apply
    );
}

void glitchStatic(inout vec2 p) {
    staticNoise(
        p,
        vec2(0.5, 0.25 / 2.0) * glitchScale,
        0.2 * glitchScale,
        2.0
    );
}

void glitchTime(vec2 p, inout float currentTime) {
    freezeTime(
        p,
        currentTime,
        vec2(0.5) * glitchScale,
        2.0
    );
}

void glitchColor(
    vec2 p,
    inout vec3 color,
    inout float wasSet
) {
    vec2 groupSize = vec2(0.75, 0.125) * glitchScale;

    float speed = 5.0;

    GlitchSeed seed = glitchSeed(
        glitchCoord(p, groupSize),
        speed
    );

    seed.prob *= 0.3;

    if (shouldApply(seed) == 1.0) {
        color = vec3(0.0);
        wasSet = 1.0;
    } else {
        wasSet = 0.0;
    }
}

// --------------------------------------------------------
// Chromatic aberration
// --------------------------------------------------------

vec4 transverseChromatic(vec2 p) {

    vec2 destCoord = p;
    vec2 direction = destCoord - vec2(0.5);

    float directionLength = length(direction);

    // Avoid normalize(0,0) at the exact center.
    if (directionLength > 0.00001) {
        direction /= directionLength;
    } else {
        direction = vec2(0.0);
    }

    vec2 velocity =
        direction
        * intensityChromatic
        * pow(directionLength, 3.0);

    float inverseSampleCount =
        1.0 / float(sampleCount);

    vec2 incrementR =
        velocity * inverseSampleCount;

    vec2 incrementG =
        velocity * 2.0 * inverseSampleCount;

    vec2 incrementB =
        velocity * 4.0 * inverseSampleCount;

    vec2 offsetR = vec2(0.0);
    vec2 offsetG = vec2(0.0);
    vec2 offsetB = vec2(0.0);

    vec4 accumulator = vec4(0.0);

    for (int i = 0; i < sampleCount; i++) {

        accumulator.r += flixel_texture2D(
            bitmap,
            destCoord + offsetR
        ).r;

        accumulator.g += flixel_texture2D(
            bitmap,
            destCoord + offsetG
        ).g;

        accumulator.b += flixel_texture2D(
            bitmap,
            destCoord + offsetB
        ).b;

        accumulator.a += flixel_texture2D(
            bitmap,
            destCoord + offsetB
        ).a;

        offsetR -= incrementR;
        offsetG -= incrementG;
        offsetB -= incrementB;
    }

    return accumulator / float(sampleCount);
}

// --------------------------------------------------------
// Main
// --------------------------------------------------------

void main() {

    float alpha = openfl_Alphav;
    vec2 p = openfl_TextureCoordv.xy;

    vec4 color = flixel_texture2D(bitmap, p);

    float wasBlack = 0.0;

    glitchSwap(p);
    // glitchTime(p, time);
    glitchStatic(p);

    color = transverseChromatic(p);

    glitchColor(
        p,
        color.rgb,
        wasBlack
    );

    if (wasBlack > 0.5) {
        color.a = 1.0;
    }

    gl_FragColor = color;
}