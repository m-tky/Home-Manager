# kitty cursor effects

`features/wayland/core.nix` manages kitty.conf and installs `shaders/` via
Home Manager's `xdg.configFile`. Requires kitty >= 0.49 and `slangc` for
custom-shader compilation (available in the current environment).

- Motion blur: kitty's built-in `cursor-trail-motion-blur`, with a 1 ms
  trigger, the standard 2-cell movement threshold and 100–400 ms decay. The shader
  subscribes to trail events, suppressing the ordinary built-in trail.
- Focus-Line: tint the active pane's cursor-height row at 3.5%, fading over
  450 ms. Runs before motion blur, leaving the cursor itself untouched.
- Find-Cursor: after the trail stops for 2 seconds, fade in a thin ring
  around the cursor, gently pulsing at 8–16% strength. Movement or focus
  loss stops it. Focus-in also arms it. Like the upstream effect, its
  animation has a one-hour limit, rearmed by movement or focus-in.
- Both local shaders preserve alpha, use kitty's current cursor color in
  linear RGB, and clip to the active pane. Existing font, theme, cursor
  blinking, background opacity and bindings remain unchanged.

The two local effects reimplement the ideas and event-driven behavior of
[FractalCodeRicardo/dev-config](https://github.com/FractalCodeRicardo/dev-config/tree/4c60d756edee166744814ad954381943930db3ed/kitty/shaders)
(Find-Cursor / Focus-Line). The upstream shaders reference
`cursor_trail_history_to` and `wrapped_time`, unavailable in kitty 0.49.2.
These versions use `cursor_trail_edge` and animation progress, size geometry
in pixels / cursor units, and replace the opaque fills with subtle RGB blends.
Kitty supplies `kitty_custom_shader_types`; do not vendor an outdated copy.

## Check / apply

From the repository root:

```sh
kitty +runpy 'import runpy; runpy.run_path("assets/kitty/check-shaders.py")'
nix-instantiate --parse features/wayland/core.nix >/dev/null
# path:. includes new files even before they have been added to Git.
home-manager switch --flake 'path:.#user@m75q'
```

Use the appropriate flake target on other machines. A switch applies ALL
pending Home Manager changes, not just these effects. After switching,
reload kitty with Ctrl+Shift+F5 or start a new kitty window.

Compilation is checked automatically; appearance still needs a visual check:
move between rows in a shell/editor, stop for >2 seconds, switch panes/tabs,
and verify that the ring vanishes on movement and focus loss. Application
cursor visibility / geometry and the movement threshold can affect whether
trail events fire; this is not an editor's semantic current-line highlight.
