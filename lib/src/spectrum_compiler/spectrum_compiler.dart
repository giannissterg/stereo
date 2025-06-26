import '../core/complex/complex.dart';

typedef ComplexSpectrumFunction = Complex Function(double frequency);

abstract interface class SpectrumCompiler<S> {
  ComplexSpectrumFunction compile(S spectrum);
} 