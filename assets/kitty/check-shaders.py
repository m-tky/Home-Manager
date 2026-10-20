"""Run with: kitty +runpy 'import runpy; runpy.run_path("assets/kitty/check-shaders.py")'"""
from pathlib import Path
from tempfile import TemporaryDirectory

from kitty.shaders.slang import (
    build_custom_shader_pipeline_glsl,
    merge_pipelines,
    parse_pipeline,
)

shader_dir = Path(__file__).resolve().parent / "shaders"
pipeline = merge_pipelines([
    parse_pipeline(str(shader_dir / "focus-line.pipeline")),
    parse_pipeline("cursor-trail-motion-blur"),
    parse_pipeline(str(shader_dir / "find-cursor.pipeline")),
])
groups = pipeline["groups"]
assert len(groups) == 3
assert "cursor-trail-move" in groups[0]["animation_start"]
assert "cursor-trail-stop" in groups[1]["animation_stop"]
assert "cursor-trail-stop" in groups[2]["animation_start"]
assert "cursor-trail-move" in groups[2]["animation_stop"]
with TemporaryDirectory(prefix="kitty-cursor-check-") as cache:
    vertex, fragment, _ = build_custom_shader_pipeline_glsl(pipeline, cache)
    assert vertex and fragment
print("OK: three event-driven groups parsed and compiled to GLSL")
