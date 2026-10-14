# flutter-vita-bench

The benchmark of [flutter-vita](https://github.com/flutter-vita/flutter-vita),
the Flutter port to the PlayStation Vita. It is a Flutter app with 36 scenes.
Each scene stresses one part of the renderer or the framework. The app runs
on the console, measures each scene, and writes a result file. A host script
compares that result with a baseline.

Use it when you change the engine, the GLES2 layer or the embedder, and you
must know whether frames got slower.

## What you need

- The flutter-vita toolchain, with `flutter-vita` on your `PATH`. See its
  [Installation](https://github.com/flutter-vita/flutter-vita#installation).
  Or set `FLUTTER_VITA_ROOT` to a checkout of it.
- A console with the bridge open, on the same network as the computer. The
  scripts find it as `fluttervita.local`.

## Run it

```bash
./tool/bench.sh
```

The script builds the app with `flutter-vita build`, installs it as
`FVTA00006`, runs all scenes on the GPU, pulls the result into `out/`, and
prints a table. It exits with 1 when a scene is slower than the baseline.

A full run takes about 4 minutes. To run only some scenes:

```bash
./tool/bench.sh --scenes route_push,route_hero
```

`./tool/bench.sh --help` shows all options.

You can also open "Vita Bench" on the console and tap Run, or start it from
the bridge's TESTS tab. The console shows the result, and the app writes the
result file to the memory card. Nothing compares it with the baseline.

## What a regression is

The script grades three values for each scene: the median frame period, the
median build time and the median raster time. A value fails when it moves
outside the spread that the scene measured for itself, and never inside 10%.

The script does not grade:

- A value whose repetitions spread more than 35%. The report lists it.
- The worst frame and the stalls. The report prints them.
- A scene whose window is too short to measure. The report lists it.

[ADR-0022](docs/adr/0022-the-bench-gate-grades-inside-each-scenes-own-spread.md)
gives the reasons and the measurements.

## The baseline

`baseline/gl.json` holds the baseline. Make it over three launches of the app,
so that a scene that changes between launches shows that change in its spread:

```bash
./tool/bench.sh --baseline
./tool/bench.sh --relaunch --baseline-add
./tool/bench.sh --relaunch --baseline-add
```

Make a new baseline after a change to the scenes, the recorder or the engine.
The script refuses to compare results from different methods, engines or
clocks. [baseline/README.md](baseline/README.md) tells which numbers are steady
and which are not.

## Contents

| Path | What it is |
|---|---|
| `lib/` | The app: the scenes, the runner and the frame recorder |
| `tool/bench.sh` | Builds, installs, runs and compares |
| `tool/bench-report.py` | The table and the gate |
| `tool/localsend-bench.py` | Times one upload to the LocalSend app on the console |
| `baseline/` | The baseline the gate compares with |
| `docs/adr/` | ADR-0017 (the benchmark) and ADR-0022 (the gate). The numbers continue the series in the flutter-vita repository |
| `docs/results/` | Records of runs that compared builds or renderers |

## History

The scenes were a tab of the gallery in the flutter-vita repository from
2026-08-24 to 2026-10-01. This repository keeps that history: `git log` shows
each file from its first commit.

## License

zlib, the same as flutter-vita. See [LICENSE](LICENSE).
