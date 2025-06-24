import '../signals/pair_signal.dart';
import 'signal_compiler.dart';

class PairSignalCompiler<A, B> implements SignalCompiler<PairSignal<A, B>> {
  final SignalCompiler<A> compiler1;
  final SignalCompiler<B> compiler2;

  PairSignalCompiler(this.compiler1, this.compiler2);

  @override
  ContinuousSignal compile(PairSignal<A, B> signal) {
    return (t) => compiler1.compile(signal.signal1)(t) + compiler2.compile(signal.signal2)(t);
  }
}
