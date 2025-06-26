import '../core/complex/complex.dart';
import 'delta_spectrum.dart';

/// Represents a sine signal in the frequency domain.
/// 
/// A sine signal A*sin(2π*f*t) in the time domain corresponds to
/// A/2 * (δ(f) - δ(-f)) in the frequency domain.
class SineSpectrum {
  const SineSpectrum({
    required this.frequency,
    required this.amplitude,
  });

  /// The frequency of the sine signal in Hz.
  final double frequency;
  
  /// The amplitude of the sine signal.
  final double amplitude;

  /// Converts this SineSpectrum to a pair of DeltaSpectrums.
  /// 
  /// Returns a tuple containing:
  /// - spectrum1: DeltaSpectrum at +frequency with amplitude amplitude/2
  /// - spectrum2: DeltaSpectrum at -frequency with amplitude -amplitude/2
  (DeltaSpectrum, DeltaSpectrum) toDeltaSpectrums() {
    return (
      DeltaSpectrum(frequency, Complex(amplitude / 2, 0)),
      DeltaSpectrum(-frequency, Complex(-amplitude / 2, 0)),
    );
  }

  /// Creates a SineSpectrum from a pair of DeltaSpectrums.
  /// 
  /// Assumes the delta spectrums represent a sine signal:
  /// - spectrum1 should be at +frequency with positive amplitude
  /// - spectrum2 should be at -frequency with negative amplitude
  factory SineSpectrum.fromDeltaSpectrums(DeltaSpectrum spectrum1, DeltaSpectrum spectrum2) {
    // Validate that the spectrums represent a sine signal
    if (spectrum1.frequency != -spectrum2.frequency) {
      throw ArgumentError('DeltaSpectrums must be at opposite frequencies for a sine signal');
    }
    
    if (spectrum1.amplitude.re != -spectrum2.amplitude.re) {
      throw ArgumentError('DeltaSpectrum amplitudes must be opposite for a sine signal');
    }
    
    final frequency = spectrum1.frequency.abs();
    final amplitude = spectrum1.amplitude.re.abs() * 2;
    
    return SineSpectrum(frequency: frequency, amplitude: amplitude);
  }
} 