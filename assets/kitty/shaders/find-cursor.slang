#language slang 2026
// Adapted from FractalCodeRicardo/dev-config's Find-Cursor; see ../README.md.
import kitty_custom_shader_types;

static const float DELAY = 2.0;
static const float ANIM_SECONDS = 3600.0;

public float4 fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float elapsed = t.animation_progress * ANIM_SECONDS;
    float4 w = d.active_window_geometry;
    float4 c = d.cursor_trail_edge; // left, right, top, bottom
    if (elapsed < DELAY || w.z <= 0.0 || w.w <= 0.0 ||
        c.y <= c.x || c.z <= c.w || d.cursor_trail_state > 0.0)
        return color;
    if (any(t.pos < w.xy) || any(t.pos > w.xy + w.zw))
        return color;
    // Leave the cursor itself untouched, even while it blinks.
    if (t.pos.x >= c.x && t.pos.x <= c.y && t.pos.y >= c.w && t.pos.y <= c.z)
        return color;

    float2 dims = max(float2(d.viewport_size_pixels) * t.viewport.zw, float2(1.0));
    float2 center = float2((c.x + c.y) * 0.5, (c.z + c.w) * 0.5);
    float radius = max(12.0, (c.z - c.w) * dims.y * 0.85);
    float dist = length((t.pos - center) * dims);
    float ring = 1.0 - smoothstep(0.5, 1.5, abs(dist - radius));
    float fadeIn = smoothstep(DELAY, DELAY + 0.4, elapsed);
    float pulse = 0.12 + 0.04 * sin((elapsed - DELAY) * 2.0);
    // Blend RGB only: keep the existing background opacity and text readable.
    return float4(lerp(color.rgb, d.cursor_color.rgb, ring * fadeIn * pulse), color.a);
}
