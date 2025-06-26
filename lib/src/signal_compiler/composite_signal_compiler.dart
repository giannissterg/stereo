import '../signals/composite_signal.dart';
import 'signal_compiler.dart';

class CompositeSignalCompiler<T> implements SignalCompiler<CompositeSignal<T>> {
  const CompositeSignalCompiler(this.compiler);

  final SignalCompiler<T> compiler;

  @override
  ContinuousSignal compile(CompositeSignal<T> signal) {
    return (t) => signal.signals.map(compiler.compile).fold(0, (sum, s) => s(t));
  }
}
