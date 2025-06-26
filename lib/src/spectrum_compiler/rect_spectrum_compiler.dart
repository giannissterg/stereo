import '../core/complex/complex.dart';
import '../spectrums/rect_spectrum.dart';
import 'spectrum_compiler.dart';

class RectSpectrumCompiler implements SpectrumCompiler<RectSpectrum> {
  @override
  ComplexSpectrumFunction compile(RectSpectrum spectrum) {
    return (double frequency) {
      // Return 1 if frequency is within the bandpass range, otherwise 0
      final isInRange = frequency >= spectrum.lowCutoff && 
                       frequency <= spectrum.highCutoff;
      return isInRange ? Complex(1, 0) : Complex.zero();
    };
  }
}