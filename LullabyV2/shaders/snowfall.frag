#pragma header

uniform float intensity = 0.0;
uniform int amount = 200;
uniform float time = 0.0;

float hash(float x) {
    return fract(sin(x * 12.9898 + 4.1414) * 43758.5453);
}

float hash2(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    vec4 color = texture2D(bitmap, openfl_TextureCoordv);
    vec2 uv = vec2(openfl_TextureCoordv.x * 2.0, openfl_TextureCoordv.y);

    // Grid: cols * rows ~= amount. Capped so the neighbor search below stays valid.
    float cols = min(floor(sqrt(float(amount) * 2.0)), 28.0);
    float rows = max(1.0, floor(cols * 0.5));
    vec2 cs = vec2(2.0 / cols, 1.0 / rows);

    // Undo the slant (same shear as the original)
    float su = uv.x - (0.5 - uv.y) * intensity * 2.0;

    float T = time * 1.5 * (0.1 + intensity);
    float c0 = floor(su / cs.x);

    // How many columns a drop can drift across (original drift is +-0.2 uv)
    float reach = min(ceil(0.2 / cs.x) + 1.0, 4.0);

    float drop = 0.0;

    for (int k = -4; k <= 4; k++) {
        float fk = float(k);
        if (abs(fk) > reach) continue;

        float id = c0 + fk;

        // Per-column speed and vertical offset (breaks row alignment)
        float speed = 0.3 + hash(id) * 0.7;
        float sv = mod(uv.y - speed * T + hash(id + 31.7), 1.0);

        float row = floor(sv / cs.y);
        vec2 cell = vec2(id, row);

        float hx = hash2(cell);
        float hy = hash2(cell + 17.3);
        float hp = hash2(cell + 41.0);   // drift phase

        // Drop position: random across the column width, drifting left/right
        float dx = (id + hx) * cs.x + 0.2 * cos(time + 6.2831 * hp);
        float dy = (row + 0.15 + 0.7 * hy) * cs.y;

        float radius = 0.001 + speed * (intensity / 0.1333333333) * 0.012;
        radius = min(radius, 0.014);     // stay inside the cell's y margin

        float d = length(vec2(su - dx, sv - dy));
        drop += 1.0 - smoothstep(0.0, radius, d);
    }

    gl_FragColor = color + vec4(0.45 * drop);
}