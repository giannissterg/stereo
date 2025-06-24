typedef ContinuousSignal = double Function(double time);

abstract interface class SignalCompiler<T> {
  ContinuousSignal compile(T signal);
}
