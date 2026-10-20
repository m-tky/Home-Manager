#language slang 2026
// Adapted from FractalCodeRicardo/dev-config's Focus-Line; see ../README.md.
import kitty_custom_shader_types;

public float4 fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float4 w = d.active_window_geometry;
    float4 c = d.cursor_trail_edge; // actual cursor-row height, not a viewport fraction
    if (w.z <= 0.0 || w.w <= 0.0 || c.y <= c.x || c.z <= c.w)
        return color;
    if (any(t.pos < w.xy) || any(t.pos > w.xy + w.zw) ||
        t.pos.y < c.w || t.pos.y > c.z)
        return color;
    if (t.pos.x >= c.x && t.pos.x <= c.y)
        return color;
    float strength = 0.035 * (1.0 - t.animation_progress);
    return float4(lerp(color.rgb, d.cursor_color.rgb, strength), color.a);
}
