import 'package:stereo/src/signal_compiler/signal_compiler.dart';
import 'package:stereo/src/signals/adsr_signal.dart';

class AdsrEnvelopeCompiler<T> implements SignalCompiler<AdsrEnvelope<T>> {
  const AdsrEnvelopeCompiler(this.signalCompiler);

  final SignalCompiler<T> signalCompiler;
  
  @override
  ContinuousSignal compile(AdsrEnvelope<T> signal) {
    return (t) {
      late final double amp;
      if (t < signal.attackTime) {
        amp = t / signal.attackTime;
      } else if (t < signal.attackTime + signal.decayTime) {
        final decayProgress = (t - signal.attackTime) / signal.decayTime;
        amp = 1 - (1 - signal.sustainLevel) * decayProgress;
      } else if (t < signal.noteDuration) {
        amp = signal.sustainLevel;
      } else if (t < signal.noteDuration + signal.releaseTime) {
        final releaseProgress = (t - signal.noteDuration) / signal.releaseTime;
        amp = signal.sustainLevel * (1 - releaseProgress);
      } else {
        amp = 0.0;
      }
      return amp * signalCompiler.compile(signal.signal)(t);
    };
  }
}
