# Glossary

The benchmark's own terms. The words it shares with the port (engine,
receiver, title id, and the rest) are in the
[flutter-vita glossary](https://github.com/flutter-vita/flutter-vita/blob/master/docs/glossary.md).
These four were there too, until the scenes moved here on 2026-10-01.

| Term | Meaning |
|---|---|
| **Scene** | The unit of the benchmark: one animation, driven by the app itself, run to completion and repeated ([ADR-0017](adr/0017-the-gallery-becomes-the-benchmark.md)). Measurement covers only the animation, never the idle around it — a 300 ms page push sampled over a two-second window is three-quarters idle, and the idle drags every average toward 60 fps. Each scene carries a `stresses` tag naming the renderer primitive it leans on, which is a label rather than a measurement and is marked as such. |
| **Stall** | Two or more consecutive frames at or below 30 fps, i.e. an interruption of 66.7 ms or longer. The benchmark's definition of *problematic*. The "two or more" is load-bearing: at 60 Hz every frame period is a multiple of 16.67 ms, so a frame that misses a single deadline already presents at 33.3 ms and reads as exactly 30 fps — a literal "below 30 fps" rule would therefore fire on every dropped frame on a console where nearly every scene drops one. |
| **Baseline** | The committed results file the benchmark gates against, taken over three launches: one `tool/bench.sh --baseline`, then two `--baseline-add`. A metric fails when the median of a scene's repetitions moves outside the scene's own spread, never tighter than 10%; a metric whose repetitions spread more than 35% is listed and not graded ([ADR-0022](adr/0022-the-bench-gate-grades-inside-each-scenes-own-spread.md)). Until 2026-10-01 the gate was 10% on the **worst-frame** time, which moved more than that between two runs of the same code. The file records the conditions it was taken under (clocks, renderer, engine revision, method), because the 444 MHz change moved every number in the project and nothing caught it. A baseline that does not say what it was measured on becomes a lie without ever being edited. |

**Bad build** — the UI-thread time in a typical *slow* frame of a scene, taken
as the median of the five slowest. Distinct from `build_ms`, which is a median
over every frame: on a route scene most frames are the transition coasting, so
`build_ms` reads 1.2 ms while the frame that builds the incoming page takes 46.
Distinct also from the largest single build, which on every scene is its cold
first frame. See [ADR-0017](adr/0017-the-gallery-becomes-the-benchmark.md).
