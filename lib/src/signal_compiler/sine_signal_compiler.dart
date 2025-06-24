import 'dart:math' as math;

import 'package:stereo/src/signal_compiler/signal_compiler.dart';
import 'package:stereo/src/signals/sine_signal.dart';

class SineSignalCompiler implements SignalCompiler<SineSignal> {
  @override
  ContinuousSignal compile(SineSignal signal) =>
      (t) => signal.amplitude * math.sin(2* math.pi * signal.frequency * t);
}

