import 'package:stereo/src/fold_time_extension.dart';
import 'package:stereo/src/signal_compiler/signal_compiler.dart';

class LinearDecayEnvelope<T> {
  const LinearDecayEnvelope(this.signal, this.duration);

  final T signal;
  final double duration;
}

class LinearDecayEnvelopeCompiler<T> implements SignalCompiler<LinearDecayEnvelope<T>> {
  const LinearDecayEnvelopeCompiler(this.compiler);

  final SignalCompiler<T> compiler;

  @override
  ContinuousSignal compile(LinearDecayEnvelope<T> signal) {
    return (time) {
      final double amp = time.foldRange(
        bounds: (0.0, signal.duration),
        inRange: (time) => 1.0 - time / signal.duration,
        outOfRange: (_) => 0.0,
      );
      return compiler.compile(signal.signal)(time * amp);
    };
  }
}
