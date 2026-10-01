// The flutter-vita benchmark: 36 scenes and nothing else. ADR-0017.
//
// Until 2026-10-01 the scenes were a tab of the gallery in the tool
// repository. A scene ran inside a Column under a strip and a Navigator, in a
// Stack whose other child was an IndexedStack of eight tabs behind an
// Offstage, and on 2026-09-14 that shell made every small scene build about
// twice as slow as it does on its own
// ([the record](../docs/results/gallery-ui-thread-2026-09-23.md)). This app is
// what that record called bench_only.dart: the part that cannot go, and
// nothing else.
//
// BenchPage stays mounted while a scene runs, because a State unmounted
// mid-run cannot make the next AnimationController.
import 'package:flutter/material.dart';

import 'bench_page.dart';
import 'runner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // A positive control for the engine's log_message_callback: if this line is
  // not in the log, nothing else in it about Dart is complete.
  print('bench: dart print reaches the engine log');
  FlutterError.onError = (details) {
    print('bench: FlutterError ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };
  runApp(const BenchApp());
}

class BenchApp extends StatelessWidget {
  const BenchApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // The gallery's theme, which every baseline before 2026-10-01 was
        // measured under. Another theme changes what the scenes paint.
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xFF4C8DFF),
          scaffoldBackgroundColor: const Color(0xFF10131A),
        ),
        home: const _Root(),
      );
}

class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> with TickerProviderStateMixin {
  final ValueNotifier<Widget?> _stage = ValueNotifier<Widget?>(null);
  final ValueNotifier<String?> _scene = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _stage.dispose();
    _scene.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder<Widget?>(
            valueListenable: _stage,
            builder: (context, stage, bench) => Stack(
              fit: StackFit.expand,
              children: [
                Offstage(offstage: stage != null, child: bench),
                if (stage != null)
                  // Material, not Scaffold. ListTile and CircleAvatar reach
                  // for Material.of(context)!, which in release is a null
                  // check on nothing. A Scaffold would add furniture the
                  // scene would then be measured painting.
                  Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: stage,
                  ),
              ],
            ),
            child: BenchPage(
              stage: _stage,
              scene: _scene,
              vsync: this,
              autoRun: switchOn(kSwitchPath),
            ),
          ),
        ),
      );
}
