import 'dart:math' as math;

import '../core/complex/complex.dart';
import '../spectrums/butterworth_spectrum.dart';
import 'spectrum_compiler.dart';

class ButterworthSpectrumCompiler implements SpectrumCompiler<ButterworthSpectrum> {
  const ButterworthSpectrumCompiler();

  @override
  ComplexSpectrumFunction compile(ButterworthSpectrum spectrum) {
    return (double frequency) {
      double gain = 1 / math.sqrt(1 + math.pow(frequency.abs() / spectrum.cutoff, 2 * spectrum.order));
      return Complex(gain, 0);
    };
  }
}
