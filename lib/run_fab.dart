import 'package:flutter/material.dart';

/// The page's one action: run every scene.
///
/// Bottom right, over the results, so the header keeps its width for the
/// status. The page is Offstage while a scene runs, so the button is never in
/// a measured frame. A list under it needs [RunFab.clearance] of bottom padding, or the
/// last row sits behind it.
///
/// No spinner while a run is going: a CircularProgressIndicator draws a frame
/// every vsync. A still hourglass and a disabled button say the same thing.
/// The gallery in flutter-vita has the same button.
class RunFab extends StatelessWidget {
  const RunFab({super.key, required this.running, required this.onRun});

  final bool running;
  final VoidCallback onRun;

  /// Bottom padding for a list the button floats over.
  static const double clearance = 72;

  /// Where the button goes in a Stack over the page.
  static Widget over(Widget child,
          {required bool running, required VoidCallback onRun}) =>
      Stack(
        fit: StackFit.expand,
        children: [
          child,
          Positioned(
            right: 16,
            bottom: 16,
            child: RunFab(running: running, onRun: onRun),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        // No Hero: a FAB with the default tag takes part in every page push,
        // and this one has nowhere to fly to.
        heroTag: null,
        onPressed: running ? null : onRun,
        icon: Icon(running ? Icons.hourglass_empty : Icons.play_arrow),
        label: Text(running ? 'Running' : 'Run'),
      );
}
