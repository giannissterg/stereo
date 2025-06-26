import 'package:stereo/src/spectrum_compiler/spectrum_compiler.dart';

import '../core/complex/complex.dart';
import '../spectrums/sine_spectrum.dart';

class SineSpectrumCompiler implements SpectrumCompiler<SineSpectrum> {
  @override
  ComplexSpectrumFunction compile(SineSpectrum spectrum) {
    return (double frequency) {
      // For a sine spectrum, we return the full amplitude when the frequency matches
      // This represents the complete sine wave, not just the delta function
      if (frequency == spectrum.frequency) {
        return Complex(spectrum.amplitude, 0);
      } else {
        return Complex.zero();
      }
    };
  }
}