import '../core/complex/complex.dart';
import '../spectrums/delta_spectrum.dart';
import 'spectrum_compiler.dart';

class DeltaSpectrumCompiler implements SpectrumCompiler<DeltaSpectrum> {
  @override
  ComplexSpectrumFunction compile(DeltaSpectrum spectrum) {
    return (double frequency) {
      // Return the amplitude if the frequency matches exactly, otherwise zero
      return (frequency == spectrum.frequency) ? spectrum.amplitude : Complex.zero();
    };
  }
} 