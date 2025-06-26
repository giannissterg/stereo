import '../core/time/fold_time_extension.dart';
import 'signal_compiler.dart';
import '../signals/triangle_signal.dart';

class TriangleSignalCompiler implements SignalCompiler<TriangleSignal> {
  @override
  ContinuousSignal compile(TriangleSignal signal) {
    final period = 1 / signal.frequency;
    return (double t) {
      final x = t % period;
      final normalized = x * signal.frequency;
      final triangle =
          4 *
              signal.amplitude *
              (normalized.foldPredicate((n) => n < 0.5, (v) => v, (v) => 1.0 - v)) -
          signal.amplitude;
      return triangle;
    };
  }
}
