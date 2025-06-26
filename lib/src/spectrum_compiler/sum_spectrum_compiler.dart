import '../spectrums/sum_spectrum.dart';
import 'spectrum_compiler.dart';

class SumSpectrumCompiler<A, B> implements SpectrumCompiler<SumSpectrum<A, B>> {
  const SumSpectrumCompiler({
    required this.compiler1,
    required this.compiler2,
  });

  final SpectrumCompiler<A> compiler1;
  final SpectrumCompiler<B> compiler2;

  @override
  ComplexSpectrumFunction compile(SumSpectrum<A, B> spectrum) {
    final function1 = compiler1.compile(spectrum.spectrum1);
    final function2 = compiler2.compile(spectrum.spectrum2);
    
    return (double frequency) {
      return function1(frequency) + function2(frequency);
    };
  }
} 