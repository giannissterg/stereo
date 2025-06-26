import 'dart:math' as math;

import 'signal_compiler.dart';
import '../signals/sine_signal.dart';

class SineSignalCompiler implements SignalCompiler<SineSignal> {
  @override
  ContinuousSignal compile(SineSignal signal) =>
      (t) => signal.amplitude * math.sin(2* math.pi * signal.frequency * t);
}

